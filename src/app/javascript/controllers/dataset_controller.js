import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "summary", "spinner"]
  static values = {
    minimumLoadingDuration: { type: Number, default: 200 },
    loadingDelay: { type: Number, default: 200 }
  }

  connect() {
    this.addTurboFrameListeners()
    this.loadingStartTime = 0
  }

  disconnect() {
    this.removeTurboFrameListeners()
  }

  toggle() {
    this.contentTarget.classList.toggle("hidden")
    this.summaryTarget.classList.toggle("hidden")
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  addTurboFrameListeners() {
    const frame = this.element.closest('turbo-frame')
    if (!frame) return

    this.startLoading = this.startLoading.bind(this)
    this.stopLoading = this.stopLoading.bind(this)

    frame.addEventListener('turbo:before-fetch-request', this.startLoading)
    frame.addEventListener('turbo:before-fetch-response', this.stopLoading)
    frame.addEventListener('turbo:fetch-request-error', this.stopLoading)
  }

  removeTurboFrameListeners() {
    const frame = this.element.closest('turbo-frame')
    if (!frame) return

    frame.removeEventListener('turbo:before-fetch-request', this.startLoading)
    frame.removeEventListener('turbo:before-fetch-response', this.stopLoading)
    frame.removeEventListener('turbo:fetch-request-error', this.stopLoading)
  }

  startLoading() {
    clearTimeout(this.loadingTimeout)
    clearTimeout(this.hideTimeout)
    
    // Record the start time
    this.loadingStartTime = Date.now()
    
    // Show loader only if request takes longer than loadingDelay
    this.loadingTimeout = setTimeout(() => {
      if (this.hasSpinnerTarget) {
        this.spinnerTarget.classList.remove('hidden')
        this.spinnerTarget.classList.add('opacity-100')
      }
    }, this.loadingDelayValue)
  }

  stopLoading() {
    clearTimeout(this.loadingTimeout)
    
    // Calculate how long the loader has been visible
    const elapsedTime = Date.now() - this.loadingStartTime
    const remainingTime = Math.max(0, this.minimumLoadingDurationValue - elapsedTime)
    
    // If loader was shown, ensure it stays visible for minimum duration
    if (!this.spinnerTarget.classList.contains('hidden')) {
      this.hideTimeout = setTimeout(() => {
        this.hideSpinner()
      }, remainingTime)
    } else {
      // If loader wasn't shown yet, cancel it
      clearTimeout(this.loadingTimeout)
    }
  }

  hideSpinner() {
    if (this.hasSpinnerTarget) {
      // Fade out then hide
      this.spinnerTarget.classList.remove('opacity-100')
      this.spinnerTarget.classList.add('opacity-0')
      
      setTimeout(() => {
        this.spinnerTarget.classList.add('hidden')
        this.spinnerTarget.classList.remove('opacity-0')
      }, 150) // Match this with CSS transition duration
    }
  }
} 