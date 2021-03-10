import haxe.io.Input;

using Main.Observables;

interface Observer {
	public function notified(sender:{}, ?data:Any):Void;
}

class Observables {
	static private var observables:Map<{}, Array<Observer>> = new Map();

	static public function addObserver(subject:{}, observer:Observer) {
		if (!observables.exists(subject))
			observables[subject] = new Array<Observer>();
		observables[subject].push(observer);
	}

	static public function notify(subject:{}, ?data:Any) {
		if (observables.exists(subject))
			for (obs in observables[subject])
				obs.notified(subject, data);
	}
}

class Presenter implements Observer {
	var m:Model;
	var v:View;

	public function new(view:View) {
		m = new Model();
		v = view;
		m.addObserver(this);
		v.Input = OnInput;
	}

	public function OnInput() {
		m.SetNumber(55);
	}

	public function notified(sender:{}, ?data:Any) {
		trace("I was notified with : " + data);
	}
}

class View {
	public function new() {}

	public function OnHelloInput() {
		if (Input != null)
			Input();
	}

	public var Input:() -> Void;
}

class Model {
	public var number(default, null):Int = 1;

	public function SetNumber(v:Int) {
		number += v;
		this.notify(number);

		return number;
	}

	public function new() {}
}

class Main {
	static function main() {
		trace("test");
		var view = new View();
		var a = new Presenter(view);
		view.OnHelloInput();
	}
}
