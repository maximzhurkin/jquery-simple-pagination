(($) ->
	methods = 
	
		init: (elements, options) ->
			form = methods.getForm(options.current, options.count, options.name)
			options.radioContainer = elements[0]

			$(elements[0]).html '<div class="simple-pagination"></div>' + form
			$(elements[0]).find('input[type=radio][name=' + options.name + ']').change ->
				page = parseInt($(this).filter(':checked').val())
				options.current = page
				methods.render elements[0], options
				return
			methods.render elements[0], options
			return

		render: (element, options) ->
			pagination = methods.generate(options.current, options.count)
			template = methods.getTemplate(pagination, options.current, options.count, options.name)

			# Добавляем в дом пагинацию
			$(element).find('.simple-pagination').html template
			methods.binding element, options
			if $(options.mirrorContainer).length
				$(options.mirrorContainer).html '<div class="simple-pagination">' + template + '</div>'
				methods.binding options.mirrorContainer, options
			return

		binding: (element, options) ->
			selectClass = '.simple-pagination__select'
			selectActiveClass = 'simple-pagination__select--active'

			# Если нажали на разделитель
			$(element).find('[data-action=pagination-spred]').click ->
				select = $(this).next() # Получим элемент селекта

				if select.hasClass(selectActiveClass) # Если селект открыт
					select.removeClass selectActiveClass # Закрываем селект
				else
					$(selectClass).removeClass selectActiveClass # Скроем все открытые селекты
					select.addClass selectActiveClass # Открыаем селект
					select.find('.simple-pagination-select').scrollTop 0 # Сросим скрол
				return
			# Если кликнули вне селекта
			$(document).click (e) ->
				if !e.target.closest(selectClass) and !e.target.closest('[data-action=pagination-spred]')
					$(selectClass).removeClass selectActiveClass # Закрываем селект
				return
			# Если кликнули по кнопке
			$(element).find('[data-action=pagination-page]').click ->
				page = parseInt($(this).data('page')) # Получаем активную страницу

				# Если кнопка активна
				if !$(this).hasClass('simple-pagination__button--disable')
					# Выбираем нужный radio
					$(options.radioContainer).find('input[value=' + page + ']').prop('checked', true).change()
					options.current = page # Запомним текущую страницу
				return
			return

		getForm: (currentPage, countPages, name) ->
			form = '<div class="simple-pagination-radio">'
			# Делаем цикл на количество страниц
			i = 1
			while i <= countPages
				# Если страница выбрана добавим checked
				checked = if i == currentPage then ' checked' else ''
				form += '<input type="radio" name="' + name + '" value="' + i + '"' + checked + '>'
				i++
			return form

		generate: (currentPage, countPages) ->
			sides = 1
			range = []
			pagination = []
			previous # Временная переменная для предыдущей страницы

			# Делаем цикл на количество страниц
			i = 1
			while i <= countPages
				# Если первая или последняя страница
				# Если от текущей страницы входят в диапозон +- sides
				if i == 1 or i == countPages or i >= currentPage - sides and i < currentPage + sides + 1
					range.push i # Добавляем во временный массив
				i++
			# Делаем цикл по временному массиву
			# Формируем результат
			for i in range
				if previous
					# Если есть предыдущая страница
					if i - previous == 2
						# Если есть пропущенная страница
						pagination.push previous + 1 # Добавляем пропущенную
					else if i - previous != 1
						# Обнаружим разрыв страниц
						pagination.push '...' # Добавляем разделитель
				pagination.push i # Нет условий просто ложим результат
				previous = i # Положим в переменную предыдущую страницу
			return pagination # Возвращаем массив готовой пагинации

		getTemplate: (pagination, currentPage, countPages, paginationName) ->
			# Формируем кнопку назад
			template = methods.getNavigationTemplate('left', currentPage, countPages)
			# Делаем цикл по пагинации
			i = 0
			while i < pagination.length
				if pagination[i] != '...' # Если не разделитель
					# Добавляем страницу в пагинацию
					template += methods.getButtonTemplate(paginationName, pagination[i], pagination[i] == currentPage)
				else
					# Добавляем разделитель
					template += methods.getSpredTemplate(pagination[i - 1], pagination[i + 1], paginationName)
				i++
			# Формируем кнопку вперед
			template += methods.getNavigationTemplate('right', currentPage, countPages)
			return template

		getNavigationTemplate: (direction, currentPage, countPages) ->
			page = currentPage
			disableClass = ''
			text = ''
			# Если первая или последняя страница сделаем стрелку неактивной
			if (direction == 'left' and page <= 1) || (direction == 'right' and page >= countPages)
				disableClass = ' simple-pagination__button--disable'
			if direction == 'left'
				if page > 1 then page = page - 1
				text = '&larr;'
			if direction == 'right'
				if page < countPages then page = page + 1
				text = '&rarr;'
			# Возвращаем кнопку
			return '<button class="simple-pagination__button' + disableClass + '" type="button" data-action="pagination-page" data-page="' + page + '">' + text + '</button>'

		getButtonTemplate: (name, value, active) ->
			# Если страница выбрана добавим checked
			activeClass = if active then ' simple-pagination__button--disable' else ''
			# Возвращаем кнопку
			return '<button class="simple-pagination__button' + activeClass + '" type="button" data-action="pagination-page" data-page="' + value + '">' + value + '</button>'

		getSpredTemplate: (left, right, paginationName) ->
			spred = '<div class="simple-pagination__spred"><button class="simple-pagination__button" type="button" data-action="pagination-spred">...</button><div class="simple-pagination__select"><div class="simple-pagination-select">'
			# Добавляем скрытые страницы
			i = left
			while i <= right
				if i != left and i != right
					spred += '<div class="simple-pagination-select__item"><button class="simple-pagination__button" type="button" data-action="pagination-page" data-page="' + i + '">' + i + '</button></div>'
				i++
			spred += '</div></div></div>'
			return spred

	jQuery.fn.simplePagination = (options) ->
		options = $.extend({
			current: 1
			count: 14
			name: 'pagination'
			mirrorContainer: ''
		}, options)
		methods.init this, options
		return

	return
) jQuery