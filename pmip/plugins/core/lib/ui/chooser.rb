import javax.swing.BorderFactory
import javax.swing.DefaultListModel
import javax.swing.JEditorPane
import javax.swing.JLabel
import javax.swing.JList
import javax.swing.JPanel
import javax.swing.JTextArea
import javax.swing.JScrollPane 
import javax.swing.SwingConstants
import javax.swing.SwingUtilities
import javax.swing.text.Document
import javax.swing.text.html.HTMLEditorKit
import javax.swing.text.html.StyleSheet

import java.awt.Color
import java.awt.BorderLayout
import java.awt.Dimension

import com.intellij.openapi.ui.popup.PopupChooserBuilder
import com.intellij.ui.ColoredListCellRenderer

class RecentFilesRenderer < ColoredListCellRenderer
  def initialize(block)
    super()
    @block = block
  end

  def customizeCellRenderer(list, value, index, selected, has_focus)
    @block.call(self, value)
  end
end

class PreviewLine
  def initialize(width)
    @text_area = JTextArea.new
    @text_area.setEditable(false)
    @text_area.setRows(1)
    @text_area.setPreferredSize(Dimension.new(width, @text_area.getFontMetrics(@text_area.getFont).getHeight))
  end

  def setText(value)
    @text_area.setText(value)
  end

  def widget
    @text_area
  end
end

class PreviewBox
  def initialize(width, height)
    @text_area = JTextArea.new
    @text_area.setEditable(false)

    @scroll_pane = JScrollPane.new(@text_area)
    @scroll_pane.setPreferredSize(Dimension.new(width, height))
  end

  def setText(value)
    @text_area.setText(value)
    @text_area.setCaretPosition(0) 
  end

  def widget
    @scroll_pane
  end
end

class HtmlPreviewBox
  def initialize(width, height)
    #TODO: rename
    @jeditor_pane = JEditorPane.new
    @jeditor_pane.setEditable(false)

    @scroll_pane = JScrollPane.new(@jeditor_pane)
    @scroll_pane.setPreferredSize(Dimension.new(width, height))

    kit = HTMLEditorKit.new
    @jeditor_pane.setEditorKit(kit)

    doc = kit.createDefaultDocument()
    @jeditor_pane.setDocument(doc)
  end

  def setText(value)
    @jeditor_pane.setText(value)
    @jeditor_pane.setCaretPosition(0)
  end

  def widget
    @scroll_pane
  end
end

class FooterPanel < JPanel
  BORDER_COLOR = Color.new(0x87, 0x87, 0x87)

  def paintComponent(graphics)
    graphics.setColor(BORDER_COLOR)
    graphics.drawLine(0, 0, self.getWidth(), 0)
  end
end

#TODO: rename?
class ListSelectionListener
  def initialize(preview, block)
    @preview = preview
    @block = block
  end

  def valueChanged(event)
    if event.firstIndex == event.lastIndex
      SwingUtilities.invokeLater(RunnableBlock.new(lambda { @preview.setText(@block.call(event).to_s) }))
    end
  end
end

class Chooser
  def initialize(title, items, width = 500, height = 500, context = PMIPContext.new)
    @title = title
    @items = items
    @width = width
    @height = height
    @context = context
  end

  def description(&block)
    @description_block = block
    self
  end

  def on_selected(&block)
    @on_selected_block = block
    self
  end

  def preview_box(&block)
    @preview_block = block
    @preview = PreviewBox.new(@width, @height)
    self
  end

  def preview_line(&block)
    @preview_block = block
    @preview = PreviewLine.new(@width)
    self
  end

  def html_preview_box(&block)
    @preview_block = block
    @preview = HtmlPreviewBox.new(@width, @height)
    self
  end

  def show(auto_execute_on_single_item = true)
    return if @items.empty?
    return @on_selected_block.call(@items.first) if !@on_selected_block.nil? && @items.size == 1 && auto_execute_on_single_item

    list_model = DefaultListModel.new
    @items.each{|i| list_model.addElement(i) }

    display_list = JList.new(list_model)
    display_list.setCellRenderer(renderer)

    builder = PopupChooserBuilder.new(display_list).setTitle(@title).setMovable(true).
            setItemChoosenCallback(callback(display_list))
    
    add_preview(display_list, builder) unless @preview.nil?

    builder.createPopup.showCenteredInCurrentWindow(@context.project)
  end

  private

  def add_preview(display_list, builder)
    display_list.getSelectionModel().addListSelectionListener(listener(display_list, @preview, @preview_block))
    footer_panel = FooterPanel.new(BorderLayout.new)
    footer_panel.setBorder(BorderFactory.createEmptyBorder(4, 4, 4, 4))
    footer_panel.add(@preview.widget)
    builder.setSouthComponent(footer_panel)
  end

  def renderer
    RecentFilesRenderer.new(lambda {|renderer, value| renderer.append(@description_block.call(value).to_s) }) unless @description_block.nil?
  end

  def callback(display_list)
    RunnableBlock.new(lambda { @on_selected_block.call(display_list.getSelectedValues()[0]) unless @on_selected_block.nil? })
  end

  def listener(display_list, widget, block)
    ListSelectionListener.new(widget, lambda { block.call(display_list.getSelectedValues()[0]) })
  end
end

#TODO:
#support for FindResult and Element out of the box
#consider support filtering and additional keystroke
#support icon
