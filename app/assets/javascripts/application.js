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
//= require jquery.ui.sortable
//= require bootsy
//= require turbolinks
//= require bootstrap
//= require fancybox
//= require jquery-fileupload/basic
//= require gritter

//= require libs/underscore-1.5.2
//= require libs/jquery.starrr
//= require libs/jquery.maskedinput
//= require libs/jquery.timeago

//= require jquery-placeholder

//= require libs/backbone-1.1.0
//= require libs/backbone.pagination
//= require libs/pdfobject
//= require libs/bootstrap-datepicker

//= require libs/jquery.sidr.min

//= require skim
//= require_tree ./templates/
//= require_tree ./helpers/
//= require backbone/dmc

//= require 'message'

$(document).ready(function(){
  $('a.fancybox').fancybox();
});

$(document).bind('page:load', function(){
  $.fancybox.init();
  $('a.fancybox').fancybox();
  $('.target-blank a').attr('target', 'blank');
});

$(document).bind('page:receive', function(){
  $(window).unbind('scroll');
});

$(document).on('click', '.comment-reply a', function(event){
  event.preventDefault();
  window.parent_id = $(event.target).data('id');
  $('html, body').animate({
    scrollTop: $('li.comment.reply').offset().top
  }, 1000);
});

$(document).on('click', '.collapse-thread', function(event){
  event.preventDefault();

  var $target = $(event.target);

  $target.parents('.comment:first').children('.comments').hide();
  $target.siblings('.expand-thread').show();
  $target.hide();
});

$(document).on('click', '.expand-thread', function(event){
  event.preventDefault();

  var $target = $(event.target);

  $target.parents('.comment:first').children('.comments').show();
  $target.siblings('.collapse-thread').show();
  $target.hide();
});
