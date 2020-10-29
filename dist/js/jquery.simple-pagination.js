(function($) {
  var methods;
  methods = {
    init: function(elements, options) {
      var form;
      form = methods.getForm(options.current, options.count, options.name);
      options.radioContainer = elements[0];
      $(elements[0]).html('<div class="simple-pagination"></div>' + form);
      $(elements[0]).find('input[type=radio][name=' + options.name + ']').change(function() {
        var page;
        page = parseInt($(this).filter(':checked').val());
        options.current = page;
        methods.render(elements[0], options);
      });
      methods.render(elements[0], options);
    },
    render: function(element, options) {
      var pagination, template;
      pagination = methods.generate(options.current, options.count);
      template = methods.getTemplate(pagination, options.current, options.count, options.name);
      $(element).find('.simple-pagination').html(template);
      methods.binding(element, options);
      if ($(options.mirrorContainer).length) {
        $(options.mirrorContainer).html('<div class="simple-pagination">' + template + '</div>');
        methods.binding(options.mirrorContainer, options);
      }
    },
    binding: function(element, options) {
      var selectActiveClass, selectClass;
      selectClass = '.simple-pagination__select';
      selectActiveClass = 'simple-pagination__select--active';
      $(element).find('[data-action=pagination-spred]').click(function() {
        var select;
        select = $(this).next();
        if (select.hasClass(selectActiveClass)) {
          select.removeClass(selectActiveClass);
        } else {
          $(selectClass).removeClass(selectActiveClass);
          select.addClass(selectActiveClass);
          select.find('.simple-pagination-select').scrollTop(0);
        }
      });
      $(document).click(function(e) {
        if (!e.target.closest(selectClass) && !e.target.closest('[data-action=pagination-spred]')) {
          $(selectClass).removeClass(selectActiveClass);
        }
      });
      $(element).find('[data-action=pagination-page]').click(function() {
        var page;
        page = parseInt($(this).data('page'));
        if (!$(this).hasClass('simple-pagination__button--disable')) {
          $(options.radioContainer).find('input[value=' + page + ']').prop('checked', true).change();
          options.current = page;
        }
      });
    },
    getForm: function(currentPage, countPages, name) {
      var checked, form, i;
      form = '<div class="simple-pagination-radio">';
      i = 1;
      while (i <= countPages) {
        checked = i === currentPage ? ' checked' : '';
        form += '<input type="radio" name="' + name + '" value="' + i + '"' + checked + '>';
        i++;
      }
      return form;
    },
    generate: function(currentPage, countPages) {
      var i, j, len, pagination, previous, range, sides;
      sides = 1;
      range = [];
      pagination = [];
      previous;
      i = 1;
      while (i <= countPages) {
        if (i === 1 || i === countPages || i >= currentPage - sides && i < currentPage + sides + 1) {
          range.push(i);
        }
        i++;
      }
      for (j = 0, len = range.length; j < len; j++) {
        i = range[j];
        if (previous) {
          if (i - previous === 2) {
            pagination.push(previous + 1);
          } else if (i - previous !== 1) {
            pagination.push('...');
          }
        }
        pagination.push(i);
        previous = i;
      }
      return pagination;
    },
    getTemplate: function(pagination, currentPage, countPages, paginationName) {
      var i, template;
      template = methods.getNavigationTemplate('left', currentPage, countPages);
      i = 0;
      while (i < pagination.length) {
        if (pagination[i] !== '...') {
          template += methods.getButtonTemplate(paginationName, pagination[i], pagination[i] === currentPage);
        } else {
          template += methods.getSpredTemplate(pagination[i - 1], pagination[i + 1], paginationName);
        }
        i++;
      }
      template += methods.getNavigationTemplate('right', currentPage, countPages);
      return template;
    },
    getNavigationTemplate: function(direction, currentPage, countPages) {
      var disableClass, page, text;
      page = currentPage;
      disableClass = '';
      text = '';
      if ((direction === 'left' && page <= 1) || (direction === 'right' && page >= countPages)) {
        disableClass = ' simple-pagination__button--disable';
      }
      if (direction === 'left') {
        if (page > 1) {
          page = page - 1;
        }
        text = '&larr;';
      }
      if (direction === 'right') {
        if (page < countPages) {
          page = page + 1;
        }
        text = '&rarr;';
      }
      return '<button class="simple-pagination__button' + disableClass + '" type="button" data-action="pagination-page" data-page="' + page + '">' + text + '</button>';
    },
    getButtonTemplate: function(name, value, active) {
      var activeClass;
      activeClass = active ? ' simple-pagination__button--disable' : '';
      return '<button class="simple-pagination__button' + activeClass + '" type="button" data-action="pagination-page" data-page="' + value + '">' + value + '</button>';
    },
    getSpredTemplate: function(left, right, paginationName) {
      var i, spred;
      spred = '<div class="simple-pagination__spred"><button class="simple-pagination__button" type="button" data-action="pagination-spred">...</button><div class="simple-pagination__select"><div class="simple-pagination-select">';
      i = left;
      while (i <= right) {
        if (i !== left && i !== right) {
          spred += '<div class="simple-pagination-select__item"><button class="simple-pagination__button" type="button" data-action="pagination-page" data-page="' + i + '">' + i + '</button></div>';
        }
        i++;
      }
      spred += '</div></div></div>';
      return spred;
    }
  };
  jQuery.fn.simplePagination = function(options) {
    var el;
    el = this;
    options = $.extend({
      current: 1,
      count: 14,
      name: 'pagination',
      mirrorContainer: ''
    }, options);
    methods.init(this, options);
    return {
      setNextPage: function() {
        if (options.current < options.count) {
          options.current = options.current + 1;
          methods.init(el, options);
        }
      },
      setPrevPage: function() {
        if (options.current > 1) {
          options.current = options.current - 1;
          methods.init(el, options);
        }
      },
      setPage: function(page) {
        if (page >= 1 && page <= options.count) {
          options.current = page;
          methods.init(el, options);
        }
      }
    };
  };
})(jQuery);
