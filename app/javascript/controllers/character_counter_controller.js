import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-counter"
export default class extends Controller {
  static classes = [ "warning" ]
  static targets = [ "input", "counter" ]
  static values = {
    max: { type: Number, default: 200 }
  }

  initialize() {
    this.count = this.countCharacters.bind(this)
    this.count()
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
      this.counterTarget.classList.add(this.warningClass)
    } else if (this.counterTarget.classList.contains(this.warningClass)){
      this.counterTarget.classList.remove(this.warningClass)
    }
  }
}
