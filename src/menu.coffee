# Description
#   Lunches near domaniewska, Warsaw
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot menu
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Konrad Przysucha <przysk01@stepstone.com>

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

module.exports = (robot) ->

  pages = ["http://www.tulipanbistro.pl/?url=menu-dnia","http://www.trinitybistro.pl/?url=menu-dnia"]

  robot.respond /menu/i, (msg) ->
    #tulipan and trinity
    for page in pages
      msg.http(page)
        .get() (err, res, body) ->
          handler = new HtmlParser.DefaultHandler()
          parser  = new HtmlParser.Parser handler
          parser.parseComplete body
          title = (Select handler.dom, "title")[0]
          danie = (Select handler.dom, "div.down div.danie")
          cena = (Select handler.dom, "div.cena")
          date = (Select handler.dom, ".day")[0]
          msg.send title.children[0].raw 
          msg.send date.children[0].raw 
          i = 0
          while i < danie.length
            msg.send danie[i].children[0].children[0].raw + "   " + cena[i].children[0].children[0].raw
            i++
          msg.send "======================\n"  
    #primapasta
    msg.http("http://primapasta.pl/business-lunch-warszawa/")
      .get() (err, res, body) ->
        handler = new HtmlParser.DefaultHandler()
        parser  = new HtmlParser.Parser handler
        res.setEncoding("UTF-8")
        parser.parseComplete body
        title = (Select handler.dom, "title")[0]
        menu = (Select handler.dom, "#natekst p")
        msg.send title.children[0].raw
        i = 0
        while i < menu.length
        	if /strong/i.test(menu[i].children[0].raw)
         		for d, j in menu[i].children[0].children
         			if d.type == 'text' 
         				msg.send d.raw.replace /^\s+|\s+$/g, ""         				
         	else
         		for d, j in menu[i].children
         			if d.type == 'text' && !/\n+$/.test(d.raw)
         				msg.send d.raw.replace /^\s+|\s+$/g, ""
         			else 
         				if d.children
         					msg.send d.children[0].raw
         	i++
        msg.send "======================\n"  




