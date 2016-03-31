////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.process {

	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import by.blooddy.crypto.events.ProcessEvent;
	
	[Event( type="by.blooddy.crypto.events.ProcessEvent", name="complete" )]
	[Event( type="by.blooddy.crypto.events.ProcessEvent", name="error" )]
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					24.03.2016 23:45:13
	 */
	public class Process extends EventDispatcher {

		CRYPTO::worker {
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const process:Process$ = ( function():Process$ {
			
			var c:Object;
			try {
				c = Process$Concurrent;
			} catch ( e:Error ) {
				c = Process$Consistent;
			}
			return c.internal::instance as Process$;
			
		}() );
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function Process(WorkerClass:Class) {
			if ( ( this as Object ).constructor == Process ) {
				Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			} else {
				super();
				if ( !WorkerClass ) {
					Error.throwError( TypeError, 2007, 'WorkerClass' );
				}
				this.WorkerClass = WorkerClass;
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var WorkerClass:Class;
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @internal
		 * @param	method
		 * @param	args
		 */
		protected function call(method:String, ...arguments):void {

			process.process(
				WorkerClass,
				getQualifiedClassName( this ), method, arguments,
				this.complete, this.error
			);

		}

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function complete(result:*):void {
			super.dispatchEvent( new ProcessEvent( ProcessEvent.COMPLETE, false, false, result ) );
		}
		
		/**
		 * @private
		 */
		private function error(error:*):void {
			if ( super.hasEventListener( ProcessEvent.ERROR ) ) {
				super.dispatchEvent( new ProcessEvent( ProcessEvent.ERROR, false, false, error ) );
			} else {
				throw error;
			}
		}

		}
		
	}

}