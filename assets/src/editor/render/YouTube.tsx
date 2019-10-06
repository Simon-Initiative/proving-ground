import * as React from 'react'
import { getData, YouTube as YouTubeData, mutate } from 'data/content/types';

export interface YouTubeProps {
  attributes: any;
  node: any;
  editor: any;
  isSelected: boolean;
  isFocused: boolean;
}

export interface YouTubeState {
  
}

class YouTube extends React.Component<YouTubeProps, YouTubeState> {
  /**
   * When the input text changes, update the `video` data on the node.
   *
   * @param {Event} e
   */

  onChange = src => {
    const { node, editor } = this.props;
    const video = getData<YouTubeData>(node.data);
    editor.setNodeByKey(node.key, { data: mutate<YouTubeData>(video, { src }) })
  }

  /**
   * When clicks happen in the input, stop propagation so that the void node
   * itself isn't focused, since that would unfocus the input.
   *
   * @type {Event} e
   */

  onClick = e => {
    e.stopPropagation()
  }

  /**
   * Render.
   *
   * @return {Element}
   */

  render() {
    const { isSelected } = this.props

    return (
      <div {...this.props.attributes}>
        {this.renderVideo()}
        {isSelected ? this.renderInput() : null}
      </div>
    )
  }

  /**
   * Render the Youtube iframe, responsively.
   *
   * @return {Element}
   */

  renderVideo = () => {
    const { node, isFocused } = this.props;
    const video = getData<YouTubeData>(node.data);

    const wrapperStyle = {
      position: 'relative',
      outline: isFocused ? '2px solid blue' : 'none',
      
    } as any;

    const maskStyle = {
      display: isFocused ? 'none' : 'block',
      position: 'absolute',
      top: '0',
      left: '0',
      height: '100%',
      width: '100%',
      cursor: 'cell',
      zIndex: 1,
    } as any;

    const iframeStyle = {
      display: 'block',
      marginLeft: 'auto',
      marginRight: 'auto',
    } as any;

    const fullSrc = `https://www.youtube.com/embed/${video.src}`;

    return (
      <div style={wrapperStyle}>
        <div style={maskStyle} />
        <iframe
          id="ytplayer"
          width="640"
          height="476"
          src={fullSrc}
          frameBorder="0"
          style={iframeStyle}
        />
      </div>
    )
  }

  /**
   * Render the video URL input.
   *
   * @return {Element}
   */

  renderInput = () => {
    const { node } = this.props
    const video = getData<YouTubeData>(node.data);
    const style = {
      marginTop: '5px',
      boxSizing: 'border-box',
    }

    return (
      <VideoUrlInput
        defaultValue={video.src}
        onChange={this.onChange}
        onClick={this.onClick}
        style={style}
      />
    )
  }
}

/**
 * The video URL input as controlled input to avoid loosing cursor position.
 *
 * @type {Component}
 */

const VideoUrlInput = props => {
  const [val, setVal] = React.useState(props.defaultValue)

  const onChange = React.useCallback(
    e => {
      setVal(e.target.value)
      props.onChange(e.target.value)
    },
    [props.onChange]
  )

  return (
    <input
      value={val}
      onChange={onChange}
      onClick={props.onClick}
      style={props.style}
    />
  )
}

/**
 * Export.
 */

export default YouTube;
