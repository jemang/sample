import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  connect() {
    console.log("connect application");
    this.missingFrame();
  }

  missingFrame() {
    console.log("response")
    document.addEventListener("turbo:frame-missing", (event) => {
      const { detail: { response, visit } } = event;
      if (process.env.NODE_ENV !== 'production') {
        console.log(`Missing Frame Detected in ${event.target.id}`);
      }
      console.log(response.url);
      event.preventDefault();
      Turbo.visit(response.url);
    });
  }

}
