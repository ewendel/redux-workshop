import React, { PropTypes } from 'react';

function Filter({ name, isActive, onNameClick }) {
  const className = isActive ? '' : 'inactive';
  return (
    <span
      className={ className }
      onClick={ onNameClick }
    >
      { name }
    </span>
  );
}

Filter.propTypes = {
  name: PropTypes.string.isRequired,
  isActive: PropTypes.bool,
  onNameClick: PropTypes.func.isRequired
};

function FilterList({ filters, onFilterActiveChange }) {
  return (
    <ul className="filterList">
      { filters.map(f =>
        <li key={ f.id }>
          <Filter
            {...f}
            onNameClick={ () => onFilterActiveChange(f, !f.isActive) }
          />
        </li>)}
    </ul>
  );
}

FilterList.propTypes = {
  filters: PropTypes.array.isRequired,
  onFilterActiveChange: PropTypes.func.isRequired
};

export default FilterList;
