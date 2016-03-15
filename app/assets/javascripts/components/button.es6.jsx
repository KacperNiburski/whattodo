class Button extends React.Component {
  render () {
    return (
      <div>
        <div>Text: {this.props.text}</div>
      </div>
    );
  }
}

Button.propTypes = {
  text: React.PropTypes.string
};
