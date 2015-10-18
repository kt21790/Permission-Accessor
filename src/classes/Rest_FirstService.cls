global class Rest_FirstService {

	webservice String parameter { get; set; }

	public Rest_FirstService() {
		this.parameter = 'value';
	}

	webservice static String serviceName(){
		return '';
	}
}