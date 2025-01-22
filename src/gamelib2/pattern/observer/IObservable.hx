package gamelib2.pattern.observer;

/**
 * An object with state that is observed by an IObserver implementation. IObserver objects will be
 * notified whenever the state changes. An update (or event) is defined as a 32-bit integer and uses
 * a bit field for storing the event id. Multiple, similar events dispatched by a single observable
 * object are grouped together into an event group and each event type is annotated with a group id
 * that uniquely identifies the event source.<br/>
 * The most significant bits (4 bits by default, see Observable.NUM_GROUP_BITS) are reserved for the
 * group id, whereas the remaining bits store the event id as a bit flag. It is therefore possible
 * to store a total of 2^<i>Observable.NUM_GROUP_BITS</i>-1 groups where each group can fire a total
 * of 32-<i>Observable.NUM_GROUP_BITS</i> different events.<br/>
 * Example:<br/>
 * <pre>
 * //uses 4 bits for the group id
 * event defined as a 32-bit integer: (g=group bits, x=event bits)
 * ggggxxxx xxxxxxxx xxxxxxxx xxxxxxxx
 * ^
 * MSB 
 * 
 * 000100000000 00000000 00000010: group id 1, event id 2 
 * 001100000000 00000001 00000000: group id 3, event id 9
 * 
 * If a group and event id is given the bits can be constructed like so:
 * type = group << (32 - Observable.NUM_GROUP_BITS) | 1 << (event - 1);
 * </pre>
 */
interface IObservable
{
	/**
	 * Registers an observer object so it is updated whenever the notify() method is called.
	 * @param o The observer to attach.
	 * @param mask An optional bitmask to block out unwanted events. Only those events that are
	 * included in the mask are let through. This can be used to improve performance (reduce
	 * function calls) or to simplify logic (less if/else/switch statements on event type). If
	 * omitted, the observer receives all updates from an event group.
	 */
	function attach(o : IObserver, ?mask : Int = 0) : Void;
	
	/**
	 * Unregisters an observer instance to stop being notified when the notify() method is called.
	 * @param o The observer to detach.
	 * @param mask The bits to remove from the existing bitmask. If all bits in the updated bitmask
	 * are zero, the observer is detached. If omitted, the observer is always detached
	 * effectively ignoring the existing bitmask.
	 */
	function detach(o : IObserver) : Void;
	
	/**
	 * Fires an event to notify all registered observers that an update occurred.
	 * @param type The event type.
	 * @param userData Optional event data. Default value is null.
	 */
	function notify(type : Int, userData : Dynamic) : Void;
}