class Question extends React.Component {
  render () {
    return (
      <div>
        <div>Text: {this.props.text}</div>
      </div>
    );
  }
}

Question.propTypes = {
  text: React.PropTypes.string
};
