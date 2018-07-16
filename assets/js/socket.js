import { Socket } from "phoenix"

let socket = new Socket("/socket")

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("version:subscribe", {})

channel.on("publish", payload => {
  console.debug("publish", payload)
  const { repo, branch, version } = payload
  document.querySelector('svg').querySelector(`#${repo}_${branch}_version`).innerHTML = version
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
