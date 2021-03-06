import Toastr from "toastr"
import { Socket } from "phoenix"

const socket = new Socket("/socket")

socket.connect()

const channel = socket.channel("version:subscribe")

channel.on("publish", ({ repo, branch, version }) => {
  svg.draw(repo, branch, version)
  Toastr.info(`Deployed ${version} to ${branch} branch`, `Deployed ${repo}`)
})

channel.join()
  .receive("ok", state => svg.drawAll(state))
  .receive("error", resp => { console.log("Unable to join", resp) })


const svg = {
  draw: (repo, branch, version) => {
    console.debug("draw", repo, branch, version)
    const element = document.querySelector(`svg #${repo} #${branch} #version tspan`)
    if (element) element.innerHTML = version
  },

  drawAll: state => {
    Object.keys(state).forEach(repo => {
      Object.keys(state[repo]).forEach(branch => {
        svg.draw(repo, branch, state[repo][branch].version)
      })
    });
  }
}
