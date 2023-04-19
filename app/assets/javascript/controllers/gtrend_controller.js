import { Controller } from "@hotwired/stimulus"
import CableReady from "cable_ready"

export default class extends Controller {
  connect() {
    const gtrendId = parseInt(this.element.id.substring("gtrend_".length), 10)

    this.channel = this.application.consumer.subscriptions.create({
      channel: 'GtrendsChannel',
      gtrend_id: gtrendId
    }, {
      received (data) {
        if (data.cableReady) CableReady.perform(data.operations)
      },
    })
  }

  disconnect() {
    this.channel.unsubscribe()
  }
}
