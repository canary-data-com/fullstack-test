export default function TradingRow({ trading }) {
  return (
    <tr>
      <td>{trading.ticker}</td>
      <td>{trading.name}</td>
      <td>{trading.startDate}</td>
      <td>{trading.shares}</td>
      <td>{trading.amount}</td>
      <td>{trading.market_cap_percentage}</td>
      <td>{trading.market_cap}</td>
    </tr>
  );
}
