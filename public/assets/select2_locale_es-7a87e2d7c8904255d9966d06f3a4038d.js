!function(e){"use strict";e.fn.select2.locales.es={formatMatches:function(e){return 1===e?"Un resultado disponible, presione enter para seleccionarlo.":e+" resultados disponibles, use las teclas de direcci\xf3n para navegar."},formatNoMatches:function(){return"No se encontraron resultados"},formatInputTooShort:function(e,r){var n=r-e.length;return"Por favor, introduzca "+n+" car"+(1==n?"\xe1cter":"acteres")},formatInputTooLong:function(e,r){var n=e.length-r;return"Por favor, elimine "+n+" car"+(1==n?"\xe1cter":"acteres")},formatSelectionTooBig:function(e){return"S\xf3lo puede seleccionar "+e+" elemento"+(1==e?"":"s")},formatLoadMore:function(){return"Cargando m\xe1s resultados\u2026"},formatSearching:function(){return"Buscando\u2026"},formatAjaxError:function(){return"La carga fall\xf3"}},e.extend(e.fn.select2.defaults,e.fn.select2.locales.es)}(jQuery);