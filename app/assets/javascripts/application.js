// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


var ready = function() {
	registerAllEditLinks();
	registerNewTaskLink();
	registerAllNewChildLinks();
}

var hideAllForms = function() {
	hideAllEditForms();
	hideAllNewChildForms();
}


// 
var hideAllEditForms = function() {
	$('form.edit_task').each(function() {
		id = this.id.match(/edit_task_([0-9]+)$/)[1];
		hideEditForm(id);
	});
}
//
var hideEditForm = function(id) {
	$.ajax({url : '/tasks/'+id, 
			type: 'GET', 
			dataType: 'json', 
			complete:function(response, status) {
				$('#task-'+id+' > div.content').html( response.responseText );
				registerEditLink(id);
				registerNewChildLink(id);
			}
		});
	event.preventDefault();
}


var hideForm = function() {
	$('#taskform').html('');
}

var hideAllNewChildForms = function() {
	$('form.new_task').remove();
}

var hideAllNewForms = function() {
	$('form.new_task').closest('li').remove();
}
// 
// 
var registerAllEditLinks = function() {
	$('a.edit-task').each(function() {
		id = this.id.match(/edit-task-([0-9]+)$/)[1];
		registerEditLink(id);
	});
}
// 
var registerEditLink = function(id) {
	$('#edit-task-'+id).click(function(event) {
		// Hide any existing forms
		hideAllForms();
		
		// show the form for this task
		var id = this.id.match(/task-([0-9]+)$/)[1];
		$.get( "/tasks/"+id+"/edit", function( data ) {
			$( "#task-"+id+" > div.content" ).html( data );
			registerEditSubmitButton(id);
			registerEditCancelButton(id);
			
		});
		event.preventDefault(); // Prevent link from following its href
	});
}

var registerAllNewChildLinks = function() {
	$('a.new-child').each(function() {
		id = this.id.match(/new-child-([0-9]+)$/)[1];
		registerNewChildLink(id);
	});
}
// 
// 
var registerNewChildLink = function(id) {
	$('#new-child-'+id).click(function(event) {
		// Hide any existing forms
		hideAllForms();
		
		// show the form for this task
		var id = this.id.match(/new-child-([0-9]+)$/)[1];
		$.get( "/tasks/new?parent_id="+id, function( data ) {
			$( "#task-"+id+" > ul.children" ).prepend( data );
			registerNewChildSubmitButton(id);
			registerNewChildCancelButton(id);
			
		});
		event.preventDefault(); // Prevent link from following its href
	});
}

// 
// 
var registerNewTaskLink = function() {
	$('a#new-task').click(function(event) {
		// Hide any existing forms
		hideAllForms();		
		// show the form for this task
		$.get( "/tasks/new", function( data ) {
			$( "div#taskform" ).html( data );
			registerNewSubmitButton();
			registerNewCancelButton();	
		});
		event.preventDefault(); // Prevent link from following its href
	});
}

var registerEditSubmitButton = function(id) {
	$('#task-'+id+' >> form >> button.task-submit').click(function(event) {
		$.ajax({url : "/tasks/"+id, 
				type : "PATCH",
				dataType : "json",
				data : $( "#edit_task_"+id ).serialize(), 
				complete : function( response, status ) {

					if (status == 'error') {
						var id = response.responseText.match(/id=['"]edit_task_([0-9]+)['"]/)[1];
						
						$("#edit_task_"+id).replaceWith( response.responseText );
						
						//var id = $('#taskform')
						
						registerEditSubmitButton(id);
						registerEditCancelButton(id);
					} else {
						var id = response.responseText.match(/id=['"]edit-task-([0-9]+)['"]/)[1];
						
						$("#task-"+id+" > div.content").html( response.responseText );
						registerEditLink(id);
						registerNewChildLink(id);
						hideAllForms();						
					}
				}
		});
		event.preventDefault();
	});
}


var registerEditCancelButton = function(id) {
	$('#task-'+id+' >> form >> button.task-cancel').click(function(event) {
		hideAllForms();
		event.preventDefault();
	});
}



var registerNewChildSubmitButton = function(id) {
	$('form.new_task >> button.task-submit').click(function(event) {
		$.ajax({url : "/tasks",
				type : "POST",
				dataType : "json",
				data : $( "#new_task" ).serialize(),
				complete : function( response, status ) {
					if (status == 'error') {
						$("#new_task").replaceWith( response.responseText );
						
						//var id = $('#taskform')
						
						registerNewChildSubmitButton();
						registerNewChildCancelButton();
					} else {
						$("#new_task").closest('ul').append( response.responseText );
						hideAllForms();
						
						var id = response.responseText.match(/id=['"]task-([0-9]+)['"]/)[1];
					
						registerEditLink(id);
						registerNewChildLink(id);
					};
				}
		});
		event.preventDefault();
	});
}


var registerNewChildCancelButton = function(id) {
	$('#new_task >> button.task-cancel').click(function(event) {
		hideAllForms();
		event.preventDefault();
	});	
}


var registerNewSubmitButton = function(id) {
	$('#taskform > form >> button.task-submit').click(function(event) {
		$.ajax({url : "/tasks",
				type : "POST",
				dataType : "json",
				data : $( "#taskform > form" ).serialize(),
				complete : function( response, status ) {
					if (status == 'error') {
						$("#taskform > form").replaceWith( response.responseText );
						
						//var id = $('#taskform')
						
						registerNewSubmitButton();
						registerNewCancelButton();
					} else {
						hideForm();
						
						$("body > ul").append( response.responseText );
						
						var id = response.responseText.match(/id=['"]([0-9]+)['"]/)[1];
					
						registerEditLink(id);
						registerNewChildLink(id);
					};
				}
		});
		event.preventDefault();
	});
}
// 	
var registerNewCancelButton = function(id) {
	$('#taskform > form >> button.task-cancel').click(function(event) {
		hideForm();
		event.preventDefault();
	});
}


$(document).ready(ready);
$(document).on('page:load', ready);

