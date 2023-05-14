import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails



// Semantic UI
// = require semantic-ui
//= require jquery_ujs
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "jquery-validation-rails"

/* jquery (turbo:load) */
$(document).on("turbo:load", function() {
  /* ドロップダウン */
  $('.ui.dropdown').dropdown();

  /* アコーディオン */
  $('.ui.accordion').accordion();

  /* フラッシュメッセージの閉じるボタン */
  // (turbo:render) パートでは必要ない
    $('.message .close').on('click', function() {
      $(this)
        .closest('.message')
        .transition('fade')
      ;
    });

  // fix menu when passed
  $('.masthead')
    .visibility({
      once: false,
      onBottomPassed: function() {
        $('.fixed.menu').transition('fade in');
      },
      onBottomPassedReverse: function() {
        $('.fixed.menu').transition('fade out');
      }
    })
  ;

  // create sidebar and attach to menu open
  $('.ui.sidebar')
    .sidebar('attach events', '.toc.item')
  ;



}); //最後尾


/* jquery (turbo:render) */
$(document).on("turbo:render", function() {
  /* ドロップダウン */
  $('.ui.dropdown').dropdown();

  /* アコーディオン */
  $('.ui.accordion').accordion();

  // fix menu when passed
  $('.masthead')
    .visibility({
      once: false,
      onBottomPassed: function() {
        $('.fixed.menu').transition('fade in');
      },
      onBottomPassedReverse: function() {
        $('.fixed.menu').transition('fade out');
      }
    })
  ;

  // create sidebar and attach to menu open
  $('.ui.sidebar')
    .sidebar('attach events', '.toc.item')
  ;



}); //最後尾;
