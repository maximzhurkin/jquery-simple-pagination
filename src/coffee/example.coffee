$(document).ready ->

	simple = $('#example-one').simplePagination
		current: 7
		count: 14
		name: 'page'
	
	$('[data-action=set-prev]').click (e) ->
		e.preventDefault()
		simple.setPrevPage()
		return
	$('[data-action=set-next]').click (e) ->
		e.preventDefault()
		simple.setNextPage()
		return
	$('[data-action=set-page]').click (e) ->
		e.preventDefault()
		simple.setPage(1)
		return
	
	$('#example-one').find('input[name=page]').change ->
		console.log $(@).val()
		return

	pagination = $('.catalog-pagination__top')

	pagination.simplePagination
		current: parseInt(pagination.data('current'))
		count: parseInt(pagination.data('count'))
		name: pagination.data('name')
		mirrorContainer: '.catalog-pagination__bottom'
	
	pagination.find('input[name=pagination]').change ->
		console.log $(@).val()
		return
	return
