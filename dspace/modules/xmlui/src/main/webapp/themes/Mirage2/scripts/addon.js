(function($) {

	        if ( $(".less").is(":hidden") ) {
                $(".ff").hide();
	        }

        $(".more").click(function(){
                $(".more").hide();
                $(".less").show();
                $(".ff").show();

        });

        $(".less").click(function(){
                $(".less").hide();
                $(".more").show();
                $(".ff").hide();

        });

	$("a.toggle-text").click(function(){
		$(this).siblings("div.toggle").toggle();
	});

	$("#main-container").append('<span title="To Top" id="totop" class="hidden-xs hidden-sm">&#8963;</span>');
            $(window).scroll( function(){
                $(window).scrollTop()>500?($("#totop:hidden").fadeIn()):$("#totop:visible").fadeOut()
            });

            $("#totop").click(function(){
                $("html, body").animate({scrollTop:0})
        });

	highlightStartTag = '<span class="highlight">';

    highlightEndTag = "</span>";

function doHighlight(bodyText, searchTerm, highlightStartTag, highlightEndTag)

{





  // find all occurences of the search term in the given text,

  // and add some "highlight" tags to them (we're not using a

  // regular expression search, because we want to filter out

  // matches that occur within HTML tags and script blocks, so

  // we have to do a little extra validation)

  var newText = "";

  var i = -1;

  var lcSearchTerm = searchTerm.toLowerCase();

  var lcBodyText = bodyText.toLowerCase();



  while (bodyText.length > 0) {

    i = lcBodyText.indexOf(lcSearchTerm, i+1);

    if (i < 0) {

      newText += bodyText;

      bodyText = "";

    } else {

      // skip anything inside an HTML tag

      if (bodyText.lastIndexOf(">", i) >= bodyText.lastIndexOf("<", i)) {

        // skip anything inside a <script> block

        if (lcBodyText.lastIndexOf("/script>", i) >= lcBodyText.lastIndexOf("<script", i)) {

          newText += bodyText.substring(0, i) + highlightStartTag + bodyText.substr(i, searchTerm.length) + highlightEndTag;

          bodyText = bodyText.substr(i + searchTerm.length);

          lcBodyText = bodyText.toLowerCase();

          i = -1;

        }

      }

    }

  }



  return newText;

}


function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}


$( document ).ready(function() {
	if ( $(window).width() > 980 && $("#ds-options a:visible").length == 0 )
	{
		$("#sidebar").remove();
		$("#main-content").attr("class", "col-xs-12 col-sm-12 col-md-12 main-content");
	}

	$("#search").click( function() {
		$(this).toggleClass("active");
		$(".container.topsearch").slideToggle();
		$(".c-search__icon").toggle();
		$(".c-nosearch__icon").toggle();
	});


	var e=$("#top-search-text").val();
	$("#top-search-text").focus(function(){$(this).val()==e&&$(this).val("")}).blur(function(){""==$(this).val()&&$(this).val(e)});

	var s=$("#aspect_discovery_SiteViewer_field_query").val();
	$("#aspect_discovery_SiteViewer_field_query").focus(function(){$(this).val()==s&&$(this).val("")}).blur(function(){""==$(this).val()&&$(this).val(s)});

	$("#ds-main").append('<button id="totop">&#x2191;</button>');
		$(window).scroll( function(){
	 	$(window).scrollTop()>300?($("#totop:hidden").fadeIn(),$("#totop").css("top",$(window).scrollTop()+$(window).height()-100)):$("#totop:visible").fadeOut();
	        if ($(window).scrollTop()>500) {
			$('.item-view-toggle').appendTo($('div.files'));
		}
		else {
			$('.item-view-toggle').appendTo($('div.item-summary-view-metadata'));
		}
	});
	$("#totop").click(function(){
		$("html, body").animate({scrollTop:0})
	});


if ($("#transcript").length ) {
        imgurl = $("#transcript p").text();
        var temp;
        $("#transcript span").each( function() {
                $.ajaxSetup({
                         'beforeSend' : function(xhr) {
                                xhr.overrideMimeType('text/html; charset=UTF-8');
                        },
			success: function() {
				//        alert('The script has received the request. You can close the browser.')
				/*if ($("#tabmenu2").length && $("#tabcontent2").html().length &gt; 2) {
                 		       $("#tabcontent2").html($("#transcript").html());
		                }*/
    			}
                });
                $('#transcript').load($(this).text(), function() {
                                $("#transcript img").each(function(data) {
                                        var src=$(this).attr("src");
                                        $(this).attr("src", imgurl + src);
                                } );
                                //alert($("#transcript script").length);
                                $("#transcript").find("script").each(function() {
                                                 //alert($(this).attr("src"));
                                                 //$(this).attr("src", $(this).attr("src").replace("http://", "https://"));
                                });
                                /*if (getUrlVars()["search"].length > 0) {
                                        $(this).html(doHighlight($(this).html(), getUrlVars()["search"], highlightStartTag, highlightEndTag));
                                }*/
				if ($("#tabmenu2").length) {
				       var act2=$("#tabmenu2 li.active a").attr("href");
					$("#tabcontent2").html($(act2.substring(0, act2.length-1)).html());
                                }


                });

        //$('#transcript').html(temp);
        });
        //$.getScript( "https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML" )
	

     }


    		if ($("#tabmenu").length) {
			
			//var acttab = $("#tabmenu li.active");

			$("#tabmenu > li > a").each( function() {
				$(this).click( function(e) {
					var acttab = $("#tabmenu li.active");
					var content = $(this).attr("href");

					if (content.charAt(0)=="#") {
						e.preventDefault();
						acttab.removeClass("active");
						$(this).parent().addClass("active");

						$(content).show().addClass('active').siblings().hide().removeClass('active');
					}
				});
			});

			var act=$("#tabmenu li.active a").attr("href");
			$(act).css("display", "block");

			
  	 }


    	if ($("#tabmenu2").length) {

                        $("#tabmenu2 > li > a").each( function() {
                                $(this).click( function(e) {
					var acttab = $("#tabmenu2 li.active");
                                        var content = $(this).attr("href");

                                        if (content.charAt(0)=="#") {
                                                e.preventDefault();

                                                acttab.removeClass("active");
                                                $(this).parent().addClass("active");
                                        }
					var act2=$("#tabmenu2 li.active a").attr("href");
					$("#tabcontent2").html($(act2.substring(0, act2.length-1)).html());
					if ((act2.startsWith("#manuscript") || act2.startswith("#print")) && ($("#transcript").length)) {
						$("#tabcontent2").height($("#transcript").height()+200);
						$("#tabcontent2").css("overflow-y", "scroll");
					} else {
						$("#tabcontent2").height("auto");
					}
                                });
                        });

			//$("#tabmenu2 li.active a").trigger("click");
			
			
   }

	

    if ($("span.fn").length > 0) {
		$("span.fn").each( function() {
                                $(this).click( function(e) {
					$(this).child("span").toggleClass("display");
				});
		});
    }

    if ($(".source").length > 0) {
	$(".source").click( function(e) {
		//$(this).next().css("display", "inline");
		$(this).next().toggle();

	});

    }

    var url = window.location.href;


 var path = window.location.pathname;
 if ( path != '/community-list' && path != '/')
 {
	$(".dyntree").remove();
 }

 $(".dyntree").click(function(){
	if ($(this).text() =='[+]') {
		$(this).text('[-]');
	}
	else {
		$(this).text('[+]');

	}
	$(this).parent().parent().siblings("ul").children("li").each( function() {
		$(this).toggle();
	});

 });


	// Insert line break into letter title between recipient and location
	if ($('h1.title').length > 0)
	{
	$('h1.title').html( $('h1.title').html().replace(', ', '<br/>') );
	}




	if ($("#language-dropdown-toggle span").text().match("^EN"))
		{
			$("li, li > a, a, h2, span").each(function() {
				if ($(this).text() == "Gesamtbriefwechsel") {$(this).text("All letters");}
				if ($(this).text() == "Kleine Korrespondenzen und einzelne Briefe")  {$(this).text("Small correspondeces and individual letters");}
				if ($(this).text() == "Offizielle Briefe") {$(this).text("Official letters");}
				if ($(this).text() == "Private Briefe") {$(this).text("Private letters");}
				if ($(this).text() == "Umfangreiche Korrespondenzen") {$(this).text("Extensive Correspondences");}
				if ($(this).text() == "Benzenberg (Johann Friedrich) Korrespondenz") {$(this).text("Benzenberg (Johann Friedrich) correspondence");}
				if ($(this).text() == "Bessel (Friedrich Wilhelm) Korrespondenz") {$(this).text("Bessel (Friedrich Wilhelm) correspondence");}
if ($(this).text() == "Bode (Johann Elert) Korrespondenz") {$(this).text("Bode (Johann Elert) correspondence");}
if ($(this).text() == "Bolyai (Wolfgang) Korrespondenz") {$(this).text("Bolyai (Wolfgang) correspondence");}
if ($(this).text() == "Encke (Johann Franz) Korrespondenz") {$(this).text("Encke (Johann Franz) correspondence");}
if ($(this).text() == "Gauß (Joseph) Korrespondenz") {$(this).text("Gauß (Joseph) correspondence");}
if ($(this).text() == "Gerling (Christian Ludwig) Korrespondenz") {$(this).text("Gerling (Christian Ludwig) correspondence");}
if ($(this).text() == "Harding (Carl Ludwig) Korrespondenz") {$(this).text("Harding (Carl Ludwig) correspondence");}
if ($(this).text() == "Hartmann (Friedrich) Korrespondenz") {$(this).text("Hartmann (Friedrich) correspondence");}
if ($(this).text() == "Hoppenstedt (Georg E. Friedrich) Korrespondenz") {$(this).text("Hoppenstedt (Georg E. Friedrich) correspondence");}
if ($(this).text() == "Humboldt (Alexander von) Korrespondenz") {$(this).text("Humboldt (Alexander von) correspondence");}
if ($(this).text() == "Lindenau (Bernhard von) Korrespondenz") {$(this).text("Lindenau (Bernhard von) correspondence");}
if ($(this).text() == "Müller (Georg Wilhelm) Korrespondenz") {$(this).text("Müller (Georg Wilhelm) correspondence");}
if ($(this).text() == "Nicolai (Bernhard) Korrespondenz") {$(this).text("Nicolai (Bernhard) correspondence");}
if ($(this).text() == "Olbers (Wilhelm) Korrespondenz") {$(this).text("Olbers (Wilhelm) correspondence");}
if ($(this).text() == "Petersen (Adolf Cornelius) Korrespondenz") {$(this).text("Petersen (Adolf Cornelius) correspondence");}
if ($(this).text() == "Repsold (Johann Georg) Korrespondenz") {$(this).text("Repsold (Johann Georg) correspondence");}
if ($(this).text() == "Rümker (Carl Ludwig Christian) Korrespondenz") {$(this).text("Rümker (Carl Ludwig Christian) correspondence");}
if ($(this).text() == "Schumacher (Heinrich Christian) Korrespondenz") {$(this).text("Schumacher (Heinrich Christian) correspondence");}
if ($(this).text() == "Weber (Wilhelm) Korrespondenz") {$(this).text("Weber (Wilhelm) correspondence");}
if ($(this).text() == "Zach (Franz Xaver Freiherr von) Korrespondenz") {$(this).text("Zach (Franz Xaver Freiherr von) correspondence");}
if ($(this).text() == "Zimmermann (Eberhard August Wilhelm von) Korrespondenz") {$(this).text("Zimmermann (Eberhard August Wilhelm von) correspondence");}

			});


		}



});

})(jQuery);
