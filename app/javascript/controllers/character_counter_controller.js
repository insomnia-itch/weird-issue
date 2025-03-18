import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-counter"
export default class extends Controller {
  static targets = [ "input", "counter" ]
  static values = {
    max: { type: Number, default: 200 }
  }

  initialize() {
    this.count = this.countCharacters.bind(this)
  }

  connect() {
    this.inputTarget.addEventListener("keyup", this.count)
  }

  disconnect() {
    this.inputTarget.removeEventListener("keyup", this.count)
  }

  countCharacters() {
    let number = this.inputTarget.value.length
    this.counterTarget.innerHTML = number.toString()

    if (number > this.maxValue) {
      this.counterTarget.classList.add("text-danger")
    } else if (this.counterTarget.classList.contains("text-danger")){
      this.counterTarget.classList.remove("text-danger")
    }
  }
}
