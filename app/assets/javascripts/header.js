/* globals $ Backbone */
(function(window) {
  var DropdownView = Backbone.View.extend({
    events: {
      'click [data-toggle="dropdown"]': 'toggle',
      'click a.dropdown-item': 'onClickItem'
    },

    constructor: function() {
      Backbone.View.apply(this, arguments);

      this.buttonEl = this.el.querySelector('[data-toggle="dropdown"]');
      this.dropdownEl = this.el.querySelector('.dropdown-menu');
      this.dismissEvent = this.dismissEvent.bind(this);
    },

    /**
     * Event triggered when the user clicks the dropdown button. May be manually called.
     *
     * @param {MouseEvent} event
     */
    toggle: function(event) {
      event && event.preventDefault();

      if (this.dropdownEl.classList.contains('show')) {
        this.dropdownEl.classList.remove('show');
        this.buttonEl.classList.remove('active');
        this.buttonEl.ariaExpanded = false;

        document.removeEventListener('click', this.dismissEvent);
      } else {
        this.dropdownEl.classList.add('show');
        this.buttonEl.classList.add('active');
        this.buttonEl.ariaExpanded = true;

        document.addEventListener('click', this.dismissEvent);
      }
    },

    /**
     * When clicking a link in the dropdown, dismiss the dropdown but don't prevent the default
     * event from firing.
     *
     * This ensures the dropdown is hidden when clicking a link which is intercepted by JS.
     */
    onClickItem: function() {
      this.toggle();
    },

    /**
     * Event triggered whenever the user click anywhere in the window. If the click was inside the
     * dropdown, it is handled as normal. Otherwise the menu is dismissed.
     */
    dismissEvent: function(event) {
      var parent = event.target.closest('.dropdown');

      if (parent !== this.el) {
        this.toggle();
      }
    }
  });

  var HeaderView = Backbone.View.extend({
    events: {
      'click #locale-button': 'updateLocaleLinks'
    },

    render: function() {
      this.el.querySelectorAll('.dropdown').forEach(function(element) {
        new DropdownView({ el: element }).render();
      });
    },

    updateLocaleLinks: function(event) {
      var links = event.target.closest('.dropdown').querySelectorAll('.dropdown-menu a');
      var path = window.location.pathname;

      links.forEach(function(linkEl) {
        var locale = linkEl.href.match(/locale=(\w+)/);

        if (locale && locale[1]) {
          linkEl.href = path + '?locale=' + locale[1];
        }
      });
    }
  });

  $(function() {
    new HeaderView({ el: document.querySelector('header.main-header') }).render();
  });

  window.HeaderView = HeaderView;
  window.DropdownView = DropdownView;
})(window);
