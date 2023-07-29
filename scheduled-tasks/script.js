const Rcon = require('rcon');
const fs = require("fs");

const rcon = new Rcon('localhost', 25575, 'mypassword');

const scheduled_tasks = JSON.parse(fs.readFileSync('/minecraft/scheduled-tasks/tasks.conf.json', 'utf8'));

const tasks_name = process.argv[2];

function wait(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function countdown() {
  const task_info = scheduled_tasks[tasks_name]
  for (const task of task_info.tasks) {
    console.log(task.command);
    rcon.send(task.command);
    await wait(task.time);
  }
}

rcon.on('auth', function() {
  console.log("Authed!");
  console.log(`Task ${tasks_name} started`);
  countdown()
    .then(() => {
      console.log(`Task ${tasks_name} completed`);
    })
    .catch((err) => {
      console.error('Error:', err);
    })
    .finally(() => {
      process.exit();
    });
}).on('response', function(str) {
  console.log("Response: " + str);

}).on('error', function(err) {
  console.log("Error: " + err);

}).on('server', function(err) {
  console.log("Server: " + err);

}).on('end', function() {
  console.log("Connection closed");
  process.exit();
});

rcon.connect();