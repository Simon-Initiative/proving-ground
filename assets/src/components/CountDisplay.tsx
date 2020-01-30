import * as React from 'react';
import { connect } from 'react-redux';
import { State } from 'state';
import { classNames } from 'utils/classNames';

export interface CountDisplayProps {
  className?: string;
  count: number;
};

/**
 * CountDisplay React Stateless Component
 */
const CountDisplay = ({ className, count }: CountDisplayProps) => {
  return (
    <div className={classNames(['CountDisplay ', className])}>
      <h2>The count is: {count}</h2>
    </div>
  );
};

interface StateProps {
  count: number;
}

interface DispatchProps {

}

type OwnProps = {
  className?: string;
};

const mapStateToProps = (state: State, ownProps: OwnProps): StateProps => {
  const { count } = state.counter;

  return {
    count
  };
};

const mapDispatchToProps = (dispatch, ownProps: OwnProps): DispatchProps => {
  return {

  };
};

export const controller = connect<StateProps, DispatchProps, OwnProps>(
  mapStateToProps,
  mapDispatchToProps,
)(CountDisplay);

export { controller as CountDisplay };
