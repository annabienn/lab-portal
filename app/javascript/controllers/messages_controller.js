import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["list", "input"]
  static values = { conversationId: Number }

  connect() {
    this.subscription = consumer.subscriptions.create(
      { channel: "MessagesChannel", conversation_id: this.conversationIdValue },
      {
        received: (data) => {
          if (data && data.html) {
            this.listTarget.insertAdjacentHTML("beforeend", data.html)
            this.listTarget.scrollTop = this.listTarget.scrollHeight
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

  clear(event) {
    if (event?.detail?.success) {
      this.inputTarget.value = ""
    }
  }
}
