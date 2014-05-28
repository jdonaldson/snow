package lumen.window;

import lumen.types.Types;
import lumen.window.Window;
import lumen.utils.Libs;

import lumen.window.WindowSystem;

/** A window manager, accessed via `app.window` */
class Windowing {

    var lib : Lumen;

        /** The list of windows in this manager */
    public var window_list : Map<Int, Window>;
        /** The number of windows in this manager */
    public var window_count : Int = 0;
        /** The concrete implementation of the window system */
    @:noCompletion public var system : WindowSystem;

    @:noCompletion public function new( _lib:Lumen ) {

        lib = _lib;
        window_list = new Map();

        system = new WindowSystem(this, lib);

        system.init();

    } //new

//Public facing API
    
        /** Create a window with the given config */
    public function create( _config:WindowConfig ) : Window {

        var _window = new Window( this, _config );

            window_list.set( _window.id, _window );
            window_count++;

        return _window;

    } //create


//Internal core API


    @:noCompletion public function on_event( _event:SystemEvent ) {

        if(_event.type == SystemEventType.window) {

            var _window_event = _event.window;
            _window_event.type = WindowEvents.typed( cast _window_event.type );

            var _window = window_list.get(_window_event.window_id);
            if(_window != null) {
                _window.on_event( _window_event );
            }

        } //only window events

    } //on_event

    @:noCompletion public function update() {

        system.update();

        for(window in window_list) {
            window.update();
        }

        for(window in window_list) {
            window.render();
        }

    } //update

    @:noCompletion public function destroy() {

        system.destroy();

    } //destroy


} //Windowing