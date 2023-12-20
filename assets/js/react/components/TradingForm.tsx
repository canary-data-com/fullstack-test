import React, { useState, useEffect } from 'react';
import axios from 'axios';
import TradingReturn from './TradingReturn';

interface TradingFormProps {
	onSubmit: (formData: FormData) => void;
}

interface FormData {
	selectedCompany: string;
}

const TradingForm: React.FC<TradingFormProps> = ({ onSubmit }) => {
	const [formData, setFormData] = useState<FormData>({
		selectedCompany: '',
	});
	const [result, setResult] = useState<FormData | null>(null);
	const [error, setError] = useState<string | null>(null);
	const [companies, setCompanies] = useState<string[]>([]); // State to hold the list of companies
	const [suggestions, setSuggestions] = useState<string[]>([]); // Suggestions for autocomplete

	useEffect(() => {
		// Fetch the list of companies when the component mounts
		const fetchCompanies = async () => {
			try {
				const response = await axios.get('/api/companies'); // Replace with your API endpoint
				console.log('API Response:', response.data); // Log the response data
				const companyTickers = Object.keys(response.data); // Extract company tickers from object keys
				setCompanies(companyTickers);
			} catch (error) {
				console.error('API Error:', error);
				setError('Error fetching company data. Please try again.');
			}
		};

		fetchCompanies();
	}, []);

	const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
		const { name, value } = event.target;
		setFormData({ ...formData, [name]: value });

		// Filter and set suggestions based on user input
		const input = value.trim().toLowerCase();
		const matchingCompanies = companies.filter((company) =>
			company.toLowerCase().includes(input)
		);
		setSuggestions(matchingCompanies);
	};

	const handleSuggestionClick = (suggestion: string) => {
		setFormData({ ...formData, selectedCompany: suggestion });
		setSuggestions([]); // Clear suggestions when a suggestion is selected
	};

	const handleSubmit = async (event: React.FormEvent) => {
		event.preventDefault();

		try {
			const response = await axios.post('/api/submit', formData);
			console.log('API Response:', response.data);
			setResult(response.data);
			setError(null);
		} catch (error) {
			console.error('API Error:', error);
			setError("Either the Ticker does not exists, or there's an error in the request. Please try again with a valid ticker.");
		}
	};

	return (
		<div>
			<form onSubmit={handleSubmit} className="w-full max-w-md mx-auto p-4">
				<div className="mb-4">
					<label htmlFor="selectedCompany" className="block text-gray-700 font-semibold mb-2">
						Type a company ticker:
					</label>
					<input
						type="text"
						id="selectedCompany"
						name="selectedCompany"
						value={formData.selectedCompany}
						onChange={handleChange}
						className="w-full p-2 rounded border border-gray-400 focus:outline-none focus:border-fuchsia-500"
						required
						autoComplete="off"
					/>
					{suggestions.length > 0 && (
						<ul className="bg-white border border-gray-300 mt-1 absolute z-10 w-full">
							{suggestions.map((suggestion) => (
								<li
									key={suggestion}
									className="cursor-pointer px-4 py-2 hover:bg-gray-200"
									onClick={() => handleSuggestionClick(suggestion)}
								>
									{suggestion}
								</li>
							))}
						</ul>
					)}
				</div>
				<div className="text-right mt-4">
					<button
						type="submit"
						className="bg-fuchsia-500 hover:bg-fs text-black font-semibold py-2 px-4 rounded"
					>
						Submit
					</button>
				</div>
			</form>
			{error && <p className="text-red-600">{error}</p>}
			{result && <TradingReturn result={result} />}
		</div>
	);
};

export default TradingForm;