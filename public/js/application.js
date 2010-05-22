$(document).ready(
	function() {
		
		$(".interactive").live("mouseover",
		function(){

			if (this.tagName == 'IMG'){
				var container = $(this).parent();
			} else {
				var container = $(this);
			}
			
			container.draggable({
					containment: 'parent',
				})
			
			$(this).resizable({
					handles: 'se'
				});
			}
		)
		
		$(".element").live("click",
			function() {
				addElementToContents($(this), $("#content_container"));
			});
			
		$("form").live('submit',
			function() {
				var items = $('#page_content').html();
				$('#staging_area').append(items);
				$('#staging_area').find('.interactive').removeClass('interactive ui-resizable ui-draggable');
				$('#staging_area').find('.ui-resizable-handle').remove()
				var stuff = $('#staging_area').html();
				$('#page_html').val(stuff);
			});
		
	}
)

function addElementToContents(item, content) {
	var text = item.html();
	var clone = item.clone();
	var height = item.height();
	var width = item.width();
	
	clone.addClass('new_item bordered interactive')
		.removeClass('element')
		.appendTo(content);
		
	$(".new_item").height(height).width(width);
	$(".new_item").removeClass("new_item");
}
