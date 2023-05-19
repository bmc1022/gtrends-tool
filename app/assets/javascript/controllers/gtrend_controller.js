import { Controller } from "@hotwired/stimulus";
import CableReady from "cable_ready";

export default class extends Controller {
  static values = {
    jobStatus: String
  };

  connect() {
    const gtrendId = parseInt(this.element.id.substring("gtrend_".length), 10);

    if (this.jobStatusValue !== "done") {
      this.channel = this.application.consumer.subscriptions.create(
        {
          channel: "GtrendsChannel",
          gtrend_id: gtrendId
        },
        {
          connected() {
            console.log(`Connected to GtrendsChannel for Gtrend #${gtrendId}`);
          },
          disconnected() {
            console.log(`Disconnected from GtrendsChannel for Gtrend #${gtrendId}`);
          },
          received(data) {
            if (data.cableReady) CableReady.perform(data.operations);
          }
        }
      );
    }
  }

  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe();
    }
  }
}
