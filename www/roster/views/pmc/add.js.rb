##   Licensed to the Apache Software Foundation (ASF) under one or more
##   contributor license agreements.  See the NOTICE file distributed with
##   this work for additional information regarding copyright ownership.
##   The ASF licenses this file to You under the Apache License, Version 2.0
##   (the "License"); you may not use this file except in compliance with
##   the License.  You may obtain a copy of the License at
## 
##       http://www.apache.org/licenses/LICENSE-2.0
## 
##   Unless required by applicable law or agreed to in writing, software
##   distributed under the License is distributed on an "AS IS" BASIS,
##   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##   See the License for the specific language governing permissions and
##   limitations under the License.

#
# Add People to a PMC
#

class PMCAdd < Vue
  mixin ProjectAdd
  options add_tag: "pmcadd", add_action: 'actions/committee'

  def initialize
    @people = []
  end

  def render
    _div.modal.fade id: $options.add_tag, tabindex: -1 do
      _div.modal_dialog do
        _div.modal_content do
          _div.modal_header.bg_info do
            _button.close 'x', data_dismiss: 'modal'
            _h4.modal_title 'Add People to the ' + @@project.display_name +
              ' Project'
            _p {
              _br
              _b 'N.B'
              _br
              _ 'To add existing committers to the PMC, please cancel this dialog. Select the committer from the list and use the Modify button.'
            }
          end

          _div.modal_body do
            _div.container_fluid do

              unless @people.empty?
                _table.table do
                  _thead do
                    _tr do
                      _th 'id'
                      _th 'name'
                      _th 'email'
                    end
                  end
                  _tbody do
                    @people.each do |person|
                      _tr do
                        _td person.id
                        _td person.name
                        _td person.mail[0]
                      end
                    end
                  end
                end
              end

              _CommitterSearch add: self.add,
                exclude: @@project.roster.keys().
                  concat(@people.map {|person| person.id})

              _p do
                _label do
                  _input type: 'checkbox', checked: @notice_elapsed
                  _a '72 hour board@ NOTICE',
                    href: 'https://www.apache.org/dev/pmc.html#notice_period'
                  _span ' period elapsed?'
                end
              end
            end
          end

          _div.modal_footer do
            _span.status 'Processing request...' if @disabled

            _button.btn.btn_default 'Cancel', data_dismiss: 'modal',
              disabled: @disabled

            plural = (@people.length > 1 ? 's' : '')

            _button.btn.btn_primary "Add as committer#{plural}", 
              data_action: 'add commit',
              onClick: self.post, disabled: (@people.empty?)

            _button.btn.btn_primary 'Add to PMC', onClick: self.post,
              data_action: 'add pmc info commit', 
              disabled: (@people.empty? or not @notice_elapsed)
          end
        end
      end
    end
  end
end
