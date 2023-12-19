import React, { useState, useEffect } from 'react';
import axios from 'axios';
import TradingReturn from './TradingReturn';

interface TradingFormProps {
	onSubmit: (formData: FormData) => void;
}

interface FormData {
	selectedCompany: string;
	transactionPerson: string;
	sharesAmount: number;
	jobTitle: string;
}

const TradingForm: React.FC<TradingFormProps> = ({ onSubmit }) => {
	const [formData, setFormData] = useState<FormData>({
		selectedCompany: '',
		transactionPerson: '',
		sharesAmount: 0,
		jobTitle: '',
	});
	const [result, setResult] = useState<FormData | null>(null);
	const [error, setError] = useState<string | null>(null);
	const [companies, setCompanies] = useState<[]>([]); // State to hold the list of companies

	useEffect(() => {
		// Fetch the list of companies when the component mounts
		const fetchCompanies = async () => {
			try {
				const response = await axios.get('/api/companies'); // Replace with your API endpoint
				console.log(response.data, 'response')
				setCompanies(response.data);
			} catch (error) {
				console.error('API Error:', error);
				setError('Error fetching company data. Please try again.');
			}
		};

		fetchCompanies();
	}, []); // Empty dependency array ensures this effect runs once when the component mounts

	const handleChange = (event: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
		const { name, value } = event.target;
		setFormData({ ...formData, [name]: value });
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
			setError('Error in the request. Please try again.');
		}
	};

	return (
		<div>
			<form onSubmit={handleSubmit} className="w-full max-w-md mx-auto p-4">
				<div className="mb-4">
					<label htmlFor="selectedCompany" className="block text-gray-700 font-semibold mb-2">
						Select Company:
					</label>
					<select
						id="selectedCompany"
						name="selectedCompany"
						value={formData.selectedCompany}
						onChange={handleChange}
						className="w-full p-2 rounded border border-gray-400 focus:outline-none focus:border-fuchsia-500"
						required
					>
						<option value="">Select a Company</option>
						{companies.map((company) => (
							<option key={company} value={company}>
								{company}
							</option>
						))}
					</select>
				</div>
				<div className="mb-4">
					<label htmlFor="transactionPerson" className="block text-gray-700 font-semibold mb-2">
						Transaction Person:
					</label>
					<input
						type="text"
						id="transactionPerson"
						name="transactionPerson"
						value={formData.transactionPerson}
						onChange={handleChange}
						placeholder='Enter the name of the person you wish to be responsible for the transaction'
						className="w-full p-2 rounded border border-gray-400 focus:outline-none focus:border-fuchsia-500"
						required
					/>
				</div>
				<div className="mb-4">
					<label htmlFor="sharesAmount" className="block text-gray-700 font-semibold mb-2">
						Shares Amount:
					</label>
					<input
						type="number"
						id="sharesAmount"
						name="sharesAmount"
						value={formData.sharesAmount}
						onChange={handleChange}
						className="w-full p-2 rounded border border-gray-400 focus:outline-none focus:border-fuchsia-500"
						required
					/>
				</div>
				<div className="mb-4">
					<label htmlFor="jobTitle" className="block text-gray-700 font-semibold mb-2">
						Job Title:
					</label>
					<input
						type="text"
						id="jobTitle"
						name="jobTitle"
						value={formData.jobTitle}
						onChange={handleChange}
						className="w-full p-2 rounded border border-gray-400 focus:outline-none focus:border-fuchsia-500"
						required
					/>
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
			{error && <p className="text-red-600">{error}</p>} {/* Display error message if present */}
			{result && <TradingReturn result={result} />} {/* Render the result component */}
		</div>
	);
};

export default TradingForm;