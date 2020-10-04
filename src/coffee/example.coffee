$(document).ready ->
	$('#example-one').simplePagination
		current: 7
		count: 14
		name: 'page'

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
