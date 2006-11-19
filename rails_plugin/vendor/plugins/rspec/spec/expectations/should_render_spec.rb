require File.dirname(__FILE__) + '/../spec_helper'

context "Given a controller spec in isolation (default) mode",
  :context_type => :controller do
  controller_name :render_spec

  specify "you should be able to state 'should_render' before a post to an action" do
    controller.should_render :template => 'render_spec/some_action'
    post 'some_action'
  end

  specify "you should be able to state 'should_render' after a post to an action" do
    post 'some_action'
    controller.should_have_rendered :template => 'render_spec/some_action'
  end

  specify "a 'should_render' expectation should fail if placed before an action that renders something different" do
    controller.should_render :template => 'non_existent_template'
    lambda do
      post 'some_action'
    end.should_fail_with "<{:template=>\"non_existent_template\"}> should == <{:template=>\"render_spec/some_action\"}>"
  end

  specify "a 'should_render' expectation should fail if placed after an action that renders something different" do
    post 'some_action'
    lambda { controller.should_have_rendered :template => 'non_existent_template' }.should_fail
  end

  specify "a 'should_render' expectation should support :text after the action" do
    post 'text_action'
    controller.should_have_rendered :text => "this the text for this action"
  end

  specify "a 'should_render' expectation should support :text before the action" do
    controller.should_render :text => "this the text for this action"
    post 'text_action'
  end
end

context "Given a controller spec in integration mode",
  :context_type => :controller do
  controller_name :render_spec
  integrate_views

  specify "you should be able to state 'should_render' before a post to an action" do
    controller.should_render :template => 'render_spec/some_action'
    post 'some_action'
  end

  specify "you should be able to state 'should_render' after a post to an action" do
    post 'some_action'
    controller.should_have_rendered :template => 'render_spec/some_action'
  end

  specify "a 'should_render' expectation should fail if placed before an action" do
    controller.should_render :template => 'non_existent_template'
    lambda { post 'some_action' }.should_fail_with "<{:template=>\"non_existent_template\"}> should == <{:template=>\"render_spec/some_action\"}>"
  end

  specify "a 'should_render' expectation should fail if placed after an action" do
    post 'some_action'
    lambda { controller.should_have_rendered :template => 'non_existent_template' }.should_fail
  end

  specify "a 'should_render' expectation should support :text after the action" do
    post 'text_action'
    controller.should_have_rendered :text => "this the text for this action"
  end

  specify "a 'should_render' expectation should support :text before the action" do
    controller.should_render :text => "this the text for this action"
    post 'text_action'
  end
end