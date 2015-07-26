# meg-select
A little plugin to manage select with select2 support

#Dependencies
 - Jquery
 - Select2 

#Features
 - Load select from array of objects(useful for ajax)
 	- value and text keys are configurable
 - Select2 support out the box
 - Require option
 - Select2 multiple
 - Default Values

# Docs
*** * *

### select.onlyLoad(opts, cb) 

Load a select with data

**Parameters**

**opts**: `obj`, Options

**opts.widgetname**: `String`, Nombre del select a aplicar.

**opts.required**: `boolean`, Avoid fill a default msj.

**opts.data**: `Array.[obj]`, Data to prefill in select .

**opts.id**: `String`, Atributo de data que es el id del select .

**opts.showname**: `String`, Atributo de data que es el nombre del select.

**cb**: `select~endCallback`, Callback function.


**Example**:
```js
select.onlyLoad({"widgetname":"aSelect","data":{"id":0,"name":"first"}})
```


### select.load(widgetname, data, opts, cb) 

Main method from load a select

**Parameters**

**widgetname**: `string`, Name of the witget to fill.

**data**: `Array.[obj]`, Data for fill into select.

**opts**: `Obj`, Options

**opts.multiple**: `boolean`, Create a select2 for multiple items

**opts.showname**: `string`, Key de data que hace de text.

**opts.id**: `string`, Key de data que hace de la val.

**opts.required**: `boolean`, Avoid fill a default msj.

**opts.default**: `string`, val del objeto que se quiere mostrar por defecto.

**cb**: `select~endCallback`, Callback function.


**Example**:
```js
select.load("aSelect",[{"id":"1","name":"First"},{"id":"2","name":"Second"}]),data = [{"id":"1","name":"First"},{"id":"2","name":"Second"}]
opts = {"select2":false,"required":true","showname":"name","id":"ide","default":"1234"}
select.load("aSelect",data,opts)
```

**Example**:
```js
select.load("aSelect",[{"id":"1","name":"First"},{"id":"2","name":"Second"}]),data = [{"id":"1","name":"First"},{"id":"2","name":"Second"}]
opts = {"select2":false,"required":true","showname":"name","id":"ide","default":"1234"}
select.load("aSelect",data,opts)
```
* * *

# TODO:
 - ~~Docs in this readme~~
 - Translate all comments and docs
 - ~~Examples in this readme~~
 - Bower package









