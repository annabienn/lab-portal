import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["panel", "sender", "body", "link", "backdrop"]

  connect() {
    this.hide()
    this.linkTarget.removeAttribute("href")
    this.linkTarget.dataset.conversationPath = ""
    this.subscription = consumer.subscriptions.create(
      { channel: "PopupMessagesChannel" },
      {
        received: (data) => {
          if (data && data.sender && data.body && data.conversation_path) {
            this.senderTarget.textContent = data.sender
            this.bodyTarget.textContent = data.body
            this.linkTarget.href = data.conversation_path
            this.linkTarget.dataset.conversationPath = data.conversation_path
            this.show()
          }
        },
      }
    )
  }

  disconnect() {
    if (this.subscription) {
      consumer.subscriptions.remove(this.subscription)
    }
  }

  show() {
    this.panelTarget.hidden = false
    this.backdropTarget.hidden = false
  }

  hide() {
    this.panelTarget.hidden = true
    this.backdropTarget.hidden = true
    if (this.linkTarget) {
      this.linkTarget.removeAttribute("href")
      this.linkTarget.dataset.conversationPath = ""
    }
  }

  open(event) {
    event?.preventDefault()
    const url = this.linkTarget?.dataset?.conversationPath || this.linkTarget?.href
    if (url) {
      this.hide()
      window.location.assign(url)
    }
  }
}
