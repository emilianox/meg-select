# -D="status:Beta" -D="milestone:112"
# <i>Project release status is {+ JSDOC.opt.D.status +}, milestone {+ JSDOC.opt.D.milestone +}.</i>
# /**
#  * @see ClassName#methodName
#  * @see The <a href="http://www.example.com">Example Project</a>.
#  */


###*
 * @exports meg/select
 * @namespace select
 * @version {{ VERSION }}
 * @author Emiliano Fernandez (emilianohfernandez@gmail.com)
 * @requires JQuery
 * @requires Select2
 * @license MEG select vs {{ VERSION }}
    Copyright 2015 Emiliano Fernandez
    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.
###
select = {}

###*
 * Load a select with data
 * @param {obj} opts Options
 * @param {String} opts.widgetname Nombre del select a aplicar.
 * @param {boolean} opts.required Avoid fill a default msj.
 * @param {obj[]} opts.data Data to prefill in select .
 * @param {String} opts.id Atributo de data que es el id del select .
 * @param {String} opts.showname Atributo de data que es el nombre del select.
 * @param {select~endCallback} cb Callback function.
 * @requires JQuery
 * @static
 * @memberof select
 * @method select.onlyLoad
 * @expose
 * @example
 * select.onlyLoad({"widgetname":"aSelect","data":{"id":0,"name":"fisrt"}})
###
select.onlyLoad = (opts, cb) ->
  #- depends Jquery
  preoptiontag = "<option value='"
  postoptiontag= "</option>"

  if opts["required"]
    options = ""
  else
    msg = if opts["data"].length > 0 then "-" else "Sin elementos."
    options = "#{preoptiontag}''>#{msg}#{postoptiontag}"

  for item in opts["data"]
    options += "#{preoptiontag}#{item[opts['id']]}'>#{item[opts['showname']]}#{postoptiontag}"


  $(opts["widgetname"]).empty().append(options)
  cb(0)

###*
 * A function to create a select2
 * @param {string} widgetname Widget to convert
 * @param {Obj} opts Options to apply
 * @param {boolean} opts.multiple Create a select2 for multiple items
 * @param {array<obj>} opts.data Data to load.
 * @param {string} opts.showname Key de opts.data que hace de text.
 * @param {string} opts.id Key de opts.data que hace de la val.
 * @param {string} opts.default val del objeto que se quiere mostrar por defecto.
 * @param {select~endCallback=} cb Callback function.
 * @requires JQuery
 * @requires Select2
 * @private
###
select.makeSelect2 = (widgetname, opts ,cb =(->)) ->
  if opts["multiple"]
    $(widgetname).prop("multiple":"multiple")
    if !opts["data"]
      opts["data"] = []
    else
      opts["data"] = JSON.parse(JSON.stringify(opts["data"]).split(opts["showname"]).join("text"))
      opts["data"] = JSON.parse(JSON.stringify(opts["data"]).split(opts["id"]).join("id"))
    if opts["default"]
      $(widgetname)["val"](opts["default"])
    $(widgetname)["select2"](
      "multiple": true
      "data": opts["data"]
    )
  else
    $(widgetname)["select2"]()
  $('.select2-container')["removeClass"]('form-control')["css"]('width','100%')
  cb(0)

###*
 * Main method from load a select
 * @param {string} widgetname Name of the witget to fill.
 * @param {Array<obj>} data Data for fill into select.
 * @param {Obj=} opts Options
 * @param {boolean=} [opts.multiple=true] Create a select2 for multiple items
 * @param {string=} [opts.showname="name"] Key de data que hace de text.
 * @param {string=} [opts.id="id"] Key de data que hace de la val.
 * @param {boolean=} [opts.required=false] Avoid fill a default msj.
 * @param {string=} opts.default val del objeto que se quiere mostrar por defecto.
 * @param {select~endCallback=} cb Callback function.
 * @example
 * select.load("aSelect",[{"id":"1","name":"First"},{"id":"2","name":"Second"}])
 * @example
 * data = [{"id":"1","name":"First"},{"id":"2","name":"Second"}]
 * opts = {"select2":false,"required":true","showname":"name","id":"ide","default":"1234"}
 * select.load("aSelect",data,opts)
 * @expose
###
select.load = (widgetname, data, opts = {}, cb =(->) ) ->

  #'select2': if window["orientation"] is undefined then true else false
  defaultsOptions =
    'id': 'id'
    'showname': 'name'
    'select2': true
    'multiple': false #debe ser un input para que funcione
    'required':false #rellena sin el - / tira alert si esta vacio
  #- merge options
  opts = $.extend({},defaultsOptions, opts)

  if (opts["required"]) and ((data == []) or (!data?))
    alert opts["widgetname"] + " esta vacio. Actulize la página para cargar los datos correctamente."

  if opts["multiple"]
    opts["data"]= data
    select.makeSelect2 widgetname,opts, cb
  else
    #- TODO: implementar load multiple rapido
    #- without select2 $(widgetname).prop("multiple":true)
    opts["data"]= data
    opts["widgetname"]= widgetname
    select.onlyLoad opts, (err)->
      if opts["default"]
        $(widgetname).val(opts["default"])
      if opts["select2"]
        select.makeSelect2(widgetname,opts)
      cb(0)

###*
 * @callback select~endCallback
 * @param {number} errorCode If != 0 is error
###

###*
 * @constructor
###
if not @["meg"]?
  @["meg"] = {}
@["meg"]["select"] = select
