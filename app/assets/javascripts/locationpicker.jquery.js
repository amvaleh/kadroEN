(function ( jQuery ) {

    /**
     * Holds google map object and related utility entities.
     * @constructor
     */
    function GMapContext(domElement, options) {
        var _map = new google.maps.Map(domElement, options);
        var _marker = new google.maps.Marker({
            position: new google.maps.LatLng(54.19335, -3.92695),
            map: _map,
            title: "من رو در جای صحیح قرار بده",
            visible: options.markerVisible,
            draggable: options.markerDraggable,
            icon: (options.markerIcon !== undefined) ? options.markerIcon : undefined
        });
        return {
            map: _map,
            marker: _marker,
            circle: null,
            location: _marker.position,
            radius: options.radius,
            locationName: options.locationName,
            addressComponents: {
                formatted_address: null,
                addressLine1: null,
                addressLine2: null,
                streetName: null,
                streetNumber: null,
                city: null,
                district: null,
                state: null,
                stateOrProvince: null
            },
            settings: options.settings,
            domContainer: domElement,
            geodecoder: new google.maps.Geocoder()
        }
    }

    // Utility functions for Google Map Manipulations
    var GmUtility = {
        /**
         * Draw a circle over the the map. Returns circle object.
         * Also writes new circle object in gmapContext.
         *
         * @param center - LatLng of the center of the circle
         * @param radius - radius in meters
         * @param gmapContext - context
         * @param options
         */
        drawCircle: function(gmapContext, center, radius, options) {
            if (gmapContext.circle != null) {
                gmapContext.circle.setMap(null);
            }
            if (radius > 0) {
                radius *= 1;
                options = jQuery.extend({
                    strokeColor: "#0000FF",
                    strokeOpacity: 0.35,
                    strokeWeight: 2,
                    fillColor: "#0000FF",
                    fillOpacity: 0.20
                }, options);
                options.map = gmapContext.map;
                options.radius = radius;
                options.center = center;
                gmapContext.circle = new google.maps.Circle(options);
                return gmapContext.circle;
            }
            return null;
        },
        /**
         *
         * @param gMapContext
         * @param location
         * @param callback
         */
        setPosition: function(gMapContext, location, callback) {
            gMapContext.location = location;
            gMapContext.marker.setPosition(location);
            gMapContext.map.panTo(location);
            this.drawCircle(gMapContext, location, gMapContext.radius, {});
            if (gMapContext.settings.enableReverseGeocode) {
                this.updateLocationName(gMapContext, callback);
            } else {
                if (callback) {
                    callback.call(this, gMapContext);
                }
            }

        },
        locationFromLatLng: function(lnlg) {
            return {latitude: lnlg.lat(), longitude: lnlg.lng()}
        },
        addressByFormat: function (addresses, format) {
            var result = null;
            for(var i = addresses.length - 1; i >= 0; i--){
                if(addresses[i].types.indexOf(format) >= 0){
                    result = addresses[i];
                }
            }
            return result || addresses[0];
        },
        updateLocationName: function(gmapContext, callback) {
            gmapContext.geodecoder.geocode({
                latLng: gmapContext.marker.position
            }, function(results, status) {
                if (status == google.maps.GeocoderStatus.OK && results.length > 0) {
                    var address = GmUtility.addressByFormat(results, gmapContext.settings.addressFormat);
                    gmapContext.locationName = address.formatted_address;
                    gmapContext.addressComponents = GmUtility.address_component_from_google_geocode(address.address_components);
                }else if (status == google.maps.GeocoderStatus.OVER_QUERY_LIMIT) {
                    return setTimeout(function () {
                        GmUtility.updateLocationName(gmapContext, callback);
                    }, 1000);
                }
                if (callback) {
                    callback.call(this, gmapContext);
                }
            });
        },
        address_component_from_google_geocode: function(address_components) {
            var result = {};
            for (var i = address_components.length-1; i>=0; i--) {
                var component = address_components[i];
                // Postal code
                if (component.types.indexOf('postal_code') >= 0) {
                    result.postalCode = component.short_name;
                }
                // Street number
                else if (component.types.indexOf('street_number') >= 0) {
                    result.streetNumber = component.short_name;
                }
                // Street name
                else if (component.types.indexOf('route') >= 0) {
                    result.streetName = component.short_name;
                }
                // City
                else if (component.types.indexOf('locality') >= 0) {
                    result.city = component.short_name;
                }
                // District
                else if (component.types.indexOf('sublocality') >= 0) {
                    result.district = component.short_name;
                }
                // State \ Province
                else if (component.types.indexOf('administrative_area_level_1') >= 0) {
                    result.stateOrProvince = component.short_name;
                }
                // State \ Province
                else if (component.types.indexOf('country') >= 0) {
                    result.country = component.short_name;
                }
            }
            result.addressLine1 = [result.streetNumber, result.streetName].join(' ').trim();
            result.addressLine2 = '';
            return result;
        }
    };

    function isPluginApplied(domObj) {
        return getContextForElement(domObj) != undefined;
    }

    function getContextForElement(domObj) {
        return jQuery(domObj).data("locationpicker");
    }

    function updateInputValues(inputBinding, gmapContext){
        if (!inputBinding) return;
        var currentLocation = GmUtility.locationFromLatLng(gmapContext.marker.position);
        if (inputBinding.latitudeInput) {
            inputBinding.latitudeInput.val(currentLocation.latitude).change();
        }
        if (inputBinding.longitudeInput) {
            inputBinding.longitudeInput.val(currentLocation.longitude).change();
        }
        if (inputBinding.radiusInput) {
            inputBinding.radiusInput.val(gmapContext.radius).change();
        }
        if (inputBinding.locationNameInput) {
            inputBinding.locationNameInput.val(gmapContext.locationName).change();
        }
    }

    function setupInputListenersInput(inputBinding, gmapContext) {
        if (inputBinding) {
            if (inputBinding.radiusInput){
                inputBinding.radiusInput.on("change", function(e) {
                    var radiusInputValue = jQuery(this).val();
                    if (!e.originalEvent || isNaN(radiusInputValue)) { return }
                    gmapContext.radius = radiusInputValue;
                    GmUtility.setPosition(gmapContext, gmapContext.location, function(context){
                        context.settings.onchanged.apply(gmapContext.domContainer,
                            [GmUtility.locationFromLatLng(context.location), context.radius, false]);
                    });
                });
            }
            if (inputBinding.locationNameInput && gmapContext.settings.enableAutocomplete) {
                var blur = false;
                gmapContext.autocomplete = new google.maps.places.Autocomplete(inputBinding.locationNameInput.get(0), gmapContext.settings.autocompleteOptions);
                google.maps.event.addListener(gmapContext.autocomplete, 'place_changed', function() {
                    blur = false;
                    var place = gmapContext.autocomplete.getPlace();
                    if (!place.geometry) {
                        gmapContext.settings.onlocationnotfound(place.name);
                        return;
                    }
                    GmUtility.setPosition(gmapContext, place.geometry.location, function(context) {
                        updateInputValues(inputBinding, context);
                        context.settings.onchanged.apply(gmapContext.domContainer,
                            [GmUtility.locationFromLatLng(context.location), context.radius, false]);
                    });
                });
                if(gmapContext.settings.enableAutocompleteBlur) {
                  inputBinding.locationNameInput.on("change", function(e) {
                    if (!e.originalEvent) { return }
                    blur = true;
                  });
                  inputBinding.locationNameInput.on("blur", function(e) {
                    if (!e.originalEvent) { return }
                    setTimeout(function() {
                        var address = jQuery(inputBinding.locationNameInput).val();
                        if (address.length > 5 && blur) {
                            blur = false;
                            gmapContext.geodecoder.geocode({'address': address}, function(results, status) {
                                if(status == google.maps.GeocoderStatus.OK  && results && results.length) {
                                    GmUtility.setPosition(gmapContext, results[0].geometry.location, function(context) {
                                        updateInputValues(inputBinding, context);
                                        context.settings.onchanged.apply(gmapContext.domContainer,
                                            [GmUtility.locationFromLatLng(context.location), context.radius, false]);
                                    });
                                }
                            });
                        }
                    }, 1000);
                  });
                }
            }
            if (inputBinding.latitudeInput) {
                inputBinding.latitudeInput.on("change", function(e) {
                    var latitudeInputValue = jQuery(this).val();
                    if (!e.originalEvent || isNaN(latitudeInputValue) ) { return }
                        GmUtility.setPosition(gmapContext, new google.maps.LatLng(latitudeInputValue, gmapContext.location.lng()), function(context){    context.settings.onchanged.apply(gmapContext.domContainer,
                            [GmUtility.locationFromLatLng(context.location), context.radius, false]);
                        updateInputValues(gmapContext.settings.inputBinding, gmapContext);
                    });
                });
            }
            if (inputBinding.longitudeInput) {
                inputBinding.longitudeInput.on("change", function(e) {
                    var longitudeInputValue = jQuery(this).val();
                    if (!e.originalEvent || isNaN(longitudeInputValue) ) { return }
                    GmUtility.setPosition(gmapContext, new google.maps.LatLng(gmapContext.location.lat(), longitudeInputValue), function(context){
                        context.settings.onchanged.apply(gmapContext.domContainer,
                            [GmUtility.locationFromLatLng(context.location), context.radius, false]);
                        updateInputValues(gmapContext.settings.inputBinding, gmapContext);
                    });
                });
            }
        }
    }

    function autosize(gmapContext) {
        google.maps.event.trigger(gmapContext.map, 'resize');
        setTimeout(function() {
            gmapContext.map.setCenter(gmapContext.marker.position);
        }, 300);
    }

    function updateMap(gmapContext, jQuerytarget, options) {
        var settings = jQuery.extend({}, jQuery.fn.locationpicker.defaults, options ),
            latNew = settings.location.latitude,
            lngNew = settings.location.longitude,
            radiusNew = settings.radius,
            latOld = gmapContext.settings.location.latitude,
            lngOld = gmapContext.settings.location.longitude,
            radiusOld = gmapContext.settings.radius;

        if (latNew == latOld && lngNew == lngOld && radiusNew == radiusOld)
        return;

        gmapContext.settings.location.latitude = latNew;
        gmapContext.settings.location.longitude = lngNew;
        gmapContext.radius = radiusNew;

        GmUtility.setPosition(gmapContext, new google.maps.LatLng(gmapContext.settings.location.latitude, gmapContext.settings.location.longitude), function(context){
            setupInputListenersInput(gmapContext.settings.inputBinding, gmapContext);
            context.settings.oninitialized(jQuerytarget);
        });
    }
    /**
     * Initializeialization:
     *  jQuery("#myMap").locationpicker(options);
     * @param options
     * @param params
     * @returns {*}
     */
    jQuery.fn.locationpicker = function( options, params ) {
        if (typeof options == 'string') { // Command provided
            var _targetDomElement = this.get(0);
            // Plug-in is not applied - nothing to do.
            if (!isPluginApplied(_targetDomElement)) return;
            var gmapContext = getContextForElement(_targetDomElement);
            switch (options) {
                case "location":
                    if (params == undefined) { // Getter
                        var location = GmUtility.locationFromLatLng(gmapContext.location);
                        location.radius = gmapContext.radius;
                        location.name = gmapContext.locationName;
                        return location;
                    } else { // Setter
                        if (params.radius) {
                            gmapContext.radius = params.radius;
                        }
                        GmUtility.setPosition(gmapContext, new google.maps.LatLng(params.latitude, params.longitude), function(gmapContext) {
                            updateInputValues(gmapContext.settings.inputBinding, gmapContext);
                        });
                    }
                    break;
                case "subscribe":
                    /**
                     * Provides interface for subscribing for GoogleMap events.
                     * See Google API documentation for details.
                     * Parameters:
                     * - event: string, name of the event
                     * - callback: function, callback function to be invoked
                     */
                    if (params == undefined) { // Getter is not available
                        return null;
                    } else {
                        var event = params.event;
                        var callback = params.callback;
                        if (!event || ! callback) {
                            console.error("LocationPicker: Invalid arguments for method \"subscribe\"")
                            return null;
                        }
                        google.maps.event.addListener(gmapContext.map, event, callback);
                    }
                    break;
                case "map":
                    /**
                     * Returns object which allows access actual google widget and marker paced on it.
                     * Structure: {
                     *  map: Instance of the google map widget
                     *  marker: marker placed on map
                     * }
                     */
                    if (params == undefined) { // Getter
                        var locationObj = GmUtility.locationFromLatLng(gmapContext.location);
                        locationObj.formattedAddress = gmapContext.locationName;
                        locationObj.addressComponents = gmapContext.addressComponents;
                        return {
                            map: gmapContext.map,
                            marker: gmapContext.marker,
                            location: locationObj
                        }
                    } else { // Setter is not available
                        return null;
                    }
                case "autosize":
                    autosize(gmapContext);
                    return this;
            }
            return null;
        }
        return this.each(function() {
            var jQuerytarget = jQuery(this);
            // If plug-in hasn't been applied before - initialize, otherwise - skip
            if (isPluginApplied(this)){
              updateMap(getContextForElement(this), jQuery(this), options);
              return;
            }
            // Plug-in initialization is required
            // Defaults
            var settings = jQuery.extend({}, jQuery.fn.locationpicker.defaults, options );
            // Initialize
            var gmapContext = new GMapContext(this, jQuery.extend({}, {
                zoom: settings.zoom,
                center: new google.maps.LatLng(settings.location.latitude, settings.location.longitude),
                mapTypeId: settings.mapTypeId,
                mapTypeControl: false,
                styles: settings.styles,
                disableDoubleClickZoom: false,
                scrollwheel: settings.scrollwheel,
                streetViewControl: false,
                radius: settings.radius,
                locationName: settings.locationName,
                settings: settings,
                autocompleteOptions : settings.autocompleteOptions,
                addressFormat: settings.addressFormat,
                draggable: settings.draggable,
                markerIcon: settings.markerIcon,
                markerDraggable: settings.markerDraggable,
                markerVisible: settings.markerVisible
            },  settings.mapOptions));
            jQuerytarget.data("locationpicker", gmapContext);
            // Subscribe GMap events
            function displayMarkerWithSelectedArea() {
                GmUtility.setPosition(gmapContext, gmapContext.marker.position, function (context) {
                    var currentLocation = GmUtility.locationFromLatLng(gmapContext.location);
                    updateInputValues(gmapContext.settings.inputBinding, gmapContext);
                    context.settings.onchanged.apply(gmapContext.domContainer, [currentLocation, context.radius, true]);
                });
            }
            if (settings.markerInCenter) {
                gmapContext.map.addListener("bounds_changed", function () {
                    if (!gmapContext.marker.dragging) {
                        gmapContext.marker.setPosition(gmapContext.map.center);
                        updateInputValues(gmapContext.settings.inputBinding, gmapContext);
                    }
                });
                gmapContext.map.addListener("idle", function () {
                    if (!gmapContext.marker.dragging) {
                        displayMarkerWithSelectedArea();
                    }
                });
            }
            google.maps.event.addListener(gmapContext.marker, "drag", function(event) {
                updateInputValues(gmapContext.settings.inputBinding, gmapContext);
            });
            google.maps.event.addListener(gmapContext.marker, "dragend", function(event) {
                displayMarkerWithSelectedArea();
            });
            GmUtility.setPosition(gmapContext, new google.maps.LatLng(settings.location.latitude, settings.location.longitude), function(context){
                updateInputValues(settings.inputBinding, gmapContext);
                // Set  input bindings if needed
                setupInputListenersInput(settings.inputBinding, gmapContext);
                context.settings.oninitialized(jQuerytarget);
            });
        });
    };
    jQuery.fn.locationpicker.defaults = {
        location: {latitude: 40.7324319, longitude: -73.82480777777776},
        locationName: "",
        radius: 500,
        zoom: 15,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        styles: [],
        mapOptions: {},
        scrollwheel: true,
        inputBinding: {
            latitudeInput: null,
            longitudeInput: null,
            radiusInput: null,
            locationNameInput: null
        },
        enableAutocomplete: false,
        enableAutocompleteBlur: false,
        autocompleteOptions: null,
        addressFormat: 'postal_code',
        enableReverseGeocode: true,
        draggable: true,
        onchanged: function(currentLocation, radius, isMarkerDropped) {},
        onlocationnotfound: function(locationName) {},
        oninitialized: function (component) {},
        // must be undefined to use the default gMaps marker
        markerIcon: "https://www.kadro.me/kadroMapMarker.png",
        markerDraggable: true,
        markerVisible : true
    }
}( jQuery ));