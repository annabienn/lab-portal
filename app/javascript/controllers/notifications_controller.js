import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["indicator", "toast", "toastText", "toastLink"]

  connect() {
    this.subscription = consumer.subscriptions.create(
      { channel: "NotificationsChannel" },
      {
        received: (data) => {
          if (data && data.message) {
            this.indicatorTarget.hidden = false
            this.showToast(data)
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

  showToast(data) {
    if (!this.hasToastTarget) return
    this.toastTextTarget.textContent = data.message
    if (data.link) {
      this.toastLinkTarget.href = data.link
      this.toastLinkTarget.hidden = false
    } else {
      this.toastLinkTarget.hidden = true
    }
    this.toastTarget.hidden = false
    clearTimeout(this.toastTimeout)
    this.toastTimeout = setTimeout(() => this.hideToast(), 5000)
  }

  hideToast() {
    if (this.hasToastTarget) {
      this.toastTarget.hidden = true
    }
  }
}
