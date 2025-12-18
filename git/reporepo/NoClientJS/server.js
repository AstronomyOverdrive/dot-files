import express from "express";
import util from "util";
import { readFile } from "node:fs";
import fs from "node:fs/promises";
import { exec } from "child_process";

const asyncExec = util.promisify(exec);
const app = express();

let ip;
let port;
let path;
let user;

// Handle requests
app.get("/", async (req, res) => {
	try {
		const header = await fs.readFile("header.html", { encoding: "utf8" });
		const footer = await fs.readFile("footer.html", { encoding: "utf8" });
		let html;
		// Create repo
		if (req.query.new !== undefined) {
			await createRepo(cleanInput(req.query.new));
			html = header + await getRepos() + "</tbody></table>" + footer;
		// Filter repos
		} else if (req.query.search !== undefined) {
			html = header + await getRepos(cleanInput(req.query.search)) + "</tbody></table>" + footer;
		// Get info about repo
		} else if (req.query.info !== undefined) {
			html = header + "</tbody></table>" + await getInfo(cleanInput(req.query.info)) + footer;
		// Delete repo
		} else if (req.query.delete !== undefined) {
			await deleteRepo(cleanInput(req.query.delete));
			html = header + await getRepos() + "</tbody></table>" + footer;
		} else {
			html = header + await getRepos() + "</tbody></table>" + footer;
		}
		res.status(200).send(html);
	} catch (error) {
		console.error(error);
		res.status(400).send("<h1>An error occured :(</h1>");
	}
});

// Get all repos and filter them (if a search phrase is provided)
async function getRepos(filter) {
	const { stdout, stderr } = await asyncExec(`ls $HOME/${path}`);
	const repos = stdout.split("\n");
	let repoString = "";
	for (let i = 0; i < repos.length; i++) {
		if (filter === undefined || repos[i].includes(filter)) {
			if (repos[i] !== "") {
				repoString += `
				<tr>
					<td><a href="./?delete=${repos[i]}" class="delBtn">X</a></td>
					<td>${repos[i]}</td>
					<td class="nomobile">git clone ${user}@${ip}:${path}${repos[i]}</td>
					<td><a href="./?info=${repos[i]}" class="infoBtn">show</a></td>
				</tr>`;
			}
		}
	}
	return repoString;
}

// Get latest commit log + files
async function getInfo(repo) {
	try {
		const commit = async () => {
			const { stdout, stderr } = await asyncExec(`cd $HOME/${path}${repo} && git log -1`);
			return stdout.replaceAll("\n", "<br>");
		}
		const files = async () => {
			const { stdout, stderr } = await asyncExec(`cd $HOME/${path}${repo} && git ls-tree -r --full-name --name-only HEAD`);
			return stdout.replaceAll("\n", "<br>");
		}
		return `
		<div id="infoBox">
			<div style="margin: 1em;">
				<a href="./">Close</a>
				<h3>${repo}</h3>
				<strong>Latest commit:</strong>
				<p>${await commit()}</p>
				<strong>Files:</strong>
				<p>${await files()}</p>
			</div>	  
		</div>`;
	} catch {
		return `
		<div id="infoBox">
			<div style="margin: 1em;">
				<a href="./">Close</a>
				<h3>${repo}</h3>
				<p>No commits yet!</p>
			</div>	  
		</div>`;
	}
}

// Create a new repo
async function createRepo(repo) {
	if (repo !== "") {
		await asyncExec(`cd $HOME && mkdir -p ${path}${repo} && cd ${path}${repo} && git init --bare`);
	}
}

// Delete a repo
async function deleteRepo(repo) {
	if (repo !== "") {
		await asyncExec(`cd $HOME && rm -rf ${path}${repo}`);
	}
}

// Prevent user from messing up sh commands
function cleanInput(string) {
	return string.replaceAll(/[^A-Za-z0-9-_]/g, "");
}

// Get settings from settings.json
readFile("settings.json", (error, data) => {
	if (error) throw error;
	const info = JSON.parse(data);
	ip = info.ip;
	port = info.httpPort;
	path = info.repoDir;
	user = info.serverUser;
	startApp();
});

// Get username if non provided and start the server
async function startApp() {
	if (user === "") {
		const { stdout, stderr } = await asyncExec("whoami");
		user = stdout.replaceAll("\n", "");
	}
	app.listen(port, ip, () => {
		console.log(`Server is live at ${ip}:${port} `);
	});
}
