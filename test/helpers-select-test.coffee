# helpers para select!
@HELPERS = {}
@HELPERS.data = [
    id: "1"
    name: "uno"
  ,
    id: "2"
    name: "dos"
  ,
    id: "3"
    name: "tres"
 ]

@HELPERS.CreateElement = (elementTypeName, cb) ->
  divname = chance.hashtag()
  elementname = chance.hashtag()
  $("body").append "<div id='" + divname.slice(1) + "'><"+elementTypeName+" id='" + elementname.slice(1) + "'></"+elementTypeName+"></div>"
  cb divname, elementname

@HELPERS.CreateSelect = (cb) ->
  HELPERS.CreateElement("select", cb)

@HELPERS.CreateInput = (cb) ->
  HELPERS.CreateElement("input", cb)

@HELPERS.loadSelect = (cb) ->
  HELPERS.CreateSelect (divname, selectname) ->
    meg.select.onlyLoad selectname, HELPERS.data, "id", "name", (err) ->
      cb divname, selectname

@HELPERS.getSelectData = (selectName,cb) ->
  values = []
  texts = []
  allopts = $(selectName).children()
  for option in allopts
    values.push $(option).val()
    texts.push $(option).text()
  cb values,texts