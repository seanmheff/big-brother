import { Socket } from "phoenix"

const socket = new Socket("/socket")

socket.connect()

const channel = socket.channel("version:subscribe")

channel.on("publish", ({ repo, branch, version }) => {
  svg.draw(repo, branch, version)
})

channel.join()
  .receive("ok", state => svg.drawAll(state))
  .receive("error", resp => { console.log("Unable to join", resp) })


const svg = {
  draw: (repo, branch, version) => {
    console.debug("draw", repo, branch, version)
    const element = document.querySelector(`svg #${repo}_${branch}_version`)
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
