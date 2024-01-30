export default function SearchBar({ filterTicker, onFilterChange, onSearchClick }) {
  return (
    <form className="d-flex" role="search" onSubmit={onSearchClick}>
    <input 
      className="form-control me-2" 
      type="search" placeholder="Ticker..." 
      aria-label="Search" 
      value={filterTicker}
      onChange={(e) => onFilterChange(e.target.value)}/>
    <button className="btn btn-outline-success" type="submit">Search</button>
  </form>
  );
}