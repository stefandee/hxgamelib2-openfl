package gamelib2.pattern.observer;

/**
 * An object observing the state of an IObservable implementation.
 */
interface IObserver
{
	/**
	 * Invoked whenever the state of an IObservable implementation has changed.
	 * @param type     The event type.
	 * @param source   The event source.
	 * @param userData The event data or null if no additional information is passed.
	 */
	function update(type : Int, source : Observable, userData : Dynamic) : Void;
}