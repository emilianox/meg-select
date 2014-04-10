test "Testing loadOnly", ->
  HELPERS.CreateSelect (divname, selectname) ->
    meg.select.onlyLoad selectname, HELPERS.data, "id", "name", ->
      @HELPERS.getSelectData selectname, (allValues,allTexts)->
        deepEqual allValues, [ "", "1", "2", "3" ], "Values load correctly"
        deepEqual allTexts, [ "-", "uno", "dos", "tres" ], "Text load correctly"
        $(selectname).remove()


  HELPERS.CreateSelect (divname, selectname) ->
    meg.select.onlyLoad selectname, [], "id", "name", ->
      @HELPERS.getSelectData selectname, (allValues,allTexts)->
        deepEqual allValues, [""] , "Empty text load correctly"
        deepEqual allTexts, ["Sin elementos."] , "Empty value load correctly"
        $(selectname).remove()

if meg.select.setID
  test "Testing setID", ->
    HELPERS.loadSelect (divname, selectname) ->
      meg.select.setID selectname, "1", (err) ->
        equal $(selectname).val() , "1", "SetID correctly"

      meg.select.setID selectname, "", (err) ->
        equal $(selectname).val() , "", "SetID empty correctly"

      $(selectname).remove()

if meg.select.makeSelect2
  test "Testing makeSelect2", ->
    HELPERS.CreateSelect (divname, selectname) ->
      meg.select.makeSelect2 selectname, {}, ->
        ok $(selectname).data("select2"), "Simple Select2"
        $(selectname).select2 "destroy"
        $(selectname).remove()

    msg = "Multiple Select2 vacio"
    HELPERS.CreateInput (divname, inputname) ->
      $(divname).prepend($('<h4>').text(msg))
      meg.select.makeSelect2 inputname,{multiple: true}, ->
        ok $(inputname).data("select2"), msg
        console.warn "Probar "+msg+" manualmente!"

    msg = "Multiple with data Select2"
    HELPERS.CreateInput (divname, inputname) ->
      $(divname).prepend($('<h4>').text(msg))
      meg.select.makeSelect2 inputname,
        multiple: true
        data: HELPERS.data
        showname: "name"
      , ->
        ok $(inputname).data("select2"), msg
        console.warn "Probar "+msg+" manualmente!"

    msg = "Multiple with data and default into input Select2"
    HELPERS.CreateInput (divname, inputname) ->
      $(divname).prepend($('<h4>').text(msg))
      meg.select.makeSelect2 inputname,
        multiple: true
        data: HELPERS.data
        showname: "name"
        default: "1,2"
      , ->
        ok $(inputname).data("select2"), msg
        console.warn "Probar "+msg+" manualmente!"

test "Testing load", ->
  # "load without opts"
  HELPERS.CreateSelect (divname, selectname) ->
    meg.select.load selectname, HELPERS.data, {}, ->
      @HELPERS.getSelectData selectname, (allValues,allTexts)->
        deepEqual allValues, [ "", "1", "2", "3" ], "NO OPTION:Values load correctly"
        deepEqual allTexts, [ "-", "uno", "dos", "tres" ], "NO OPTION:Text load correctly"
        ok $(selectname).data("select2"), "NO OPTION:Select2 exist"

        $(selectname).select2 "destroy"
        $(selectname).remove()

  # "load select simple with opts"
  HELPERS.CreateSelect (divname, selectname) ->
    data = [{mujaja: "1",loco: "uno"},
            {mujaja: "2",loco: "dos"},
            {mujaja: "3",loco: "tres"}]
    opts =
      id: "mujaja"
      showname: "loco"
      default: "2"

    meg.select.load selectname, data, opts, ->
      @HELPERS.getSelectData selectname, (allValues,allTexts)->
        deepEqual allValues, [ "", "1", "2", "3" ], "LOAD with OPTION:Values load correctly"
        deepEqual allTexts, [ "-", "uno", "dos", "tres" ], "LOAD with OPTION:Text load correctly"
        deepEqual allTexts, [ "-", "uno", "dos", "tres" ], "LOAD with OPTION:Text load correctly"
        ok $(selectname).val() is "2", "LOAD with OPTION:SetID seted correctly"
        ok $(selectname).data("select2"), "LOAD with OPTION:Select2 exist"

        $(selectname).select2 "destroy"
        $(selectname).remove()

  # "load select simple mobile with opts"
  HELPERS.CreateSelect (divname, selectname) ->
    data = [{mujaja: "1",loco: "uno"},
            {mujaja: "2",loco: "dos"},
            {mujaja: "3",loco: "tres"}]
    opts =
      id: "mujaja"
      showname: "loco"
      default: "2"
      select2: false
      multiple: false

    meg.select.load selectname, data, opts, ->
      @HELPERS.getSelectData selectname, (allValues,allTexts)->
        deepEqual allValues, [ "", "1", "2", "3" ], "MOBILE OPTION:Values load correctly"
        deepEqual allTexts, [ "-", "uno", "dos", "tres" ], "MOBILE OPTION:Text load correctly"
        deepEqual allTexts, [ "-", "uno", "dos", "tres" ], "MOBILE OPTION:Text load correctly"
        ok $(selectname).val() is "2", "MOBILE OPTION:SetID seted correctly"
        ok $(selectname).data("select2") == undefined, "MOBILE OPTION: Not Simple Select2"
        $(selectname).remove()

  msg = "Load select multiple with opts"
  HELPERS.CreateInput (divname, inputname)->
    data = [{mujaja: "1",loco: "uno"},
            {mujaja: "2",loco: "dos"},
            {mujaja: "3",loco: "tres"}]
    opts =
      id: "mujaja"
      showname: "loco"
      select2: false
      multiple: true
      default: "3,1"

    $(divname).prepend $('<h4>').text(msg)
    meg.select.load inputname,data, opts, ->
      ok $(inputname).data("select2"), msg
      console.warn "Probar "+msg+" manualmente!"