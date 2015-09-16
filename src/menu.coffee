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

