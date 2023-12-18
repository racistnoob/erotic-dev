window.addEventListener('message', function (event) {
	let e = event.data;

	if (e.show == true) {
		$(".incompatible-screen").fadeIn(250)
	} else if (e.show == false) {
		$(".incompatible-screen").fadeOut(250)
	}
})