###*
@license MEG select vs {{ VERSION }}
Informatica MEG - 2014 Todos los derechos reservados
###
#- DEPENDENCIES = JQUERY 1,7+, SELECT2 3.6+
select = {}
###* @expose ###
select.onlyLoad = (widgetname, data, id, showname, cb) ->
  #- depends Jquery
  if data.length > 0
    msg = "-"
  else
    msg = "Sin elementos."

  preoptiontag = "<option value="
  postoptiontag= "</option>"
  options = "#{preoptiontag}''>#{msg}#{postoptiontag}"
  
  for item in data
    options += "#{preoptiontag}#{item[id]}>#{item[showname]}#{postoptiontag}"

  
  $(widgetname).empty().append(options)
  cb(0)

select.setID = (widgetname, id, cb =(->)) ->
  #- depends Jquery
  $(widgetname).val(id);
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
      "initSelection": (widget, callback) ->
        selectedElements = []
        if widget["val"]() isnt ""
          dataIndexObj = {}
          for item in opts["data"]
            dataIndexObj[item.id] = item.text
          listIdsInInput = widget["val"]()["split"](",")
          for idInInput in listIdsInInput
            selectedElements.push 
              "id": idInInput
              "text": dataIndexObj[idInInput]
        callback(selectedElements);
    )
  else
    $(widgetname)["select2"]()
  $('.select2-container')["removeClass"]('form-control')["css"]('width','100%')
  cb(0)



###* @expose ###
select.load = (widgetname, data, opts = {}, cb =(->) ) ->
  #- data is a JSON
  #- widgetname is a namestring(not a jquery object)

  #- the optionss
  #- opts.default  (representa el id que queres que se muestre por defecto)
  defaultsOptions = 
    'id': 'id'
    'showname': 'name'
    'select2': if window["orientation"] is undefined then true else false
    'multiple': false #debe ser un input para que funcione
  #- merge options
  opts = $.extend({},defaultsOptions, opts);

  if opts["multiple"]
      opts["data"]= data
      select.makeSelect2 widgetname,opts, cb
  else
    #- TODO: implementar load multiple without select2 $(widgetname).prop("multiple":true)
    select.onlyLoad widgetname, data, opts["id"], opts["showname"], (err)->
      if opts["default"]
        select.setID(widgetname,opts["default"])
      if opts["select2"]
        select.makeSelect2(widgetname,opts)
      cb(0)

if not @["meg"]?
  @["meg"] = {}
@["meg"]["select"] = select