class Result extends React.Component {
  render () {
    return (
      <div>
        <div>Text: {this.props.text}</div>
      </div>
    );
  }
}

Result.propTypes = {
  text: React.PropTypes.string
};
