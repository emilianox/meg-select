###*
 * @exports meg/select
 * @namespace select
 * @version {{ VERSION }}
 * @license MEG select vs {{ VERSION }}
Informatica MEG - 2014 Todos los derechos reservados
###
#- DEPENDENCIES = JQUERY 1,7+, SELECT2 3.6+
select = {}

###*
 * Load a select with data
 * @param  {obj} opts Options
 * @param  {String} opts.widgetname Nombre del select a aplicar.
 * @param  {boolean} opts.required Avoid fill a default msj.
 * @param  {obj[]} opts.data Data to prefill in select .
 * @param  {String} opts.id Atributo de data que es el id del select .
 * @param  {String} opts.showname Atributo de data que es el nombre del select.
 * @param  {Function} cb Funcion a la cual llamar cuando termina
 * @memberof select
 * @method onlyLoad
 * @expose
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
 * @param  {String} widgetname Nobre del widget a setear.
###
select.setID = (widgetname, id, cb =(->)) ->
  #- depends Jquery
  $(widgetname).val id
  cb(0)

select.makeSelect2 = (widgetname, opts ,cb =(->)) ->
  ###
  opts utilizadas aca
  opts =
    multiple
    data
    default
  ###
  #- depends Jquery, Select2
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



###* @expose ###
select.load = (widgetname, data, opts = {}, cb =(->) ) ->
  #- data is a JSON(list of dicts)
  #- widgetname is a namestring(not a jquery object)

  #- the optionss
  #- opts.default  (representa el id que queres que se muestre por defecto)
  defaultsOptions =
    'id': 'id'
    'showname': 'name'
    'select2': if window["orientation"] is undefined then true else false
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
        select.setID(widgetname,opts["default"])
      if opts["select2"]
        select.makeSelect2(widgetname,opts)
      cb(0)

if not @["meg"]?
  @["meg"] = {}
@["meg"]["select"] = select
